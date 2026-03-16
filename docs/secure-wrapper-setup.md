---
uplink: "[[Projects MOC]]"
status: "[[🌲]]"
tags: [security, infrastructure, setup]
date: 2026-03-16
---

# Secure Wrapper Setup

Credential isolation system for OpenClaw. Hal (the AI agent) can execute operations via wrapper scripts but **cannot read** the underlying secrets.

## Architecture

```
hal (agent process)
  │
  ├─ sudo -u hal-admin /home/hal-admin/scripts/gcal.sh
  ├─ sudo -u hal-admin /home/hal-admin/scripts/git-ops.sh
  ├─ sudo -u hal-admin /home/hal-admin/scripts/github-api.sh
  └─ sudo -u hal-admin /home/hal-admin/scripts/check-env.sh
        │
        └─ reads from /home/hal-admin/credentials/ (600, hal-admin:hal-admin)
```

**Key principle:** hal can *execute* wrappers (via NOPASSWD sudoers) but cannot *read* credential files. If the agent session is compromised, an attacker can use tools but cannot exfiltrate credentials.

## What's Protected vs Exposed

| Credential | Protected? | Why |
|---|---|---|
| Google Calendar service account | ✅ Yes | Accessed only via gcal.sh wrapper |
| GitHub PAT | ✅ Yes | Accessed only via github-api.sh wrapper |
| SSH deploy keys | ✅ Yes | Accessed only via git-ops.sh wrapper |
| Anthropic API key | ❌ No | OpenClaw process needs it at startup |
| Telegram bot token | ❌ No | OpenClaw process needs it at startup |

OpenClaw runtime tokens (`~/.env`) must be readable by hal since the process itself needs them. This is an inherent limitation — the agent IS the process.

## Directory Structure

### Credentials (`/home/hal-admin/credentials/`)
```
600 hal-admin:hal-admin  calendar-service-account.json  ← Google Cloud service account
600 hal-admin:hal-admin  github-token.txt               ← GitHub PAT
600 hal-admin:hal-admin  id_snapjack                    ← SSH deploy key (read-only)
600 hal-admin:hal-admin  id_dotfiles                    ← SSH deploy key (read-write)
```

### Scripts (`/home/hal-admin/scripts/`)
```
750 hal-admin:hal-admin  gcal.sh              ← Google Calendar operations
640 hal-admin:hal-admin  gcal-helper.js       ← Node.js Google Calendar API logic
750 hal-admin:hal-admin  git-ops.sh           ← Git push/pull/fetch with deploy keys
750 hal-admin:hal-admin  github-api.sh        ← GitHub REST API calls
750 hal-admin:hal-admin  check-env.sh         ← Check env vars without revealing values
750 hal-admin:hal-admin  restart-hal.sh       ← Restart OpenClaw gateway
    hal-admin:hal-admin  node_modules/        ← googleapis npm package
    hal-admin:hal-admin  package.json
```

### Sudoers (`/etc/sudoers.d/hal-scripts`)
```
hal ALL=(hal-admin) NOPASSWD: /home/hal-admin/scripts/gcal.sh *
hal ALL=(hal-admin) NOPASSWD: /home/hal-admin/scripts/git-ops.sh *
hal ALL=(hal-admin) NOPASSWD: /home/hal-admin/scripts/github-api.sh *
hal ALL=(hal-admin) NOPASSWD: /home/hal-admin/scripts/check-env.sh *
```
File permissions: `440 root:root`

### SystemD Override (`/etc/systemd/system/openclaw.service.d/sudo.conf`)
```ini
[Service]
NoNewPrivileges=false
```
Required because the default OpenClaw service sets `NoNewPrivileges=true`, which blocks sudo.

## Setup From Scratch

### Prerequisites
- Debian host with `hal` user (runs OpenClaw) and `hal-admin` user (holds secrets)
- hal-admin has sudo access
- OpenClaw installed and running as system service

### Step 1: Create directories (as hal-admin)
```bash
mkdir -p ~/credentials ~/scripts
```

### Step 2: Place credentials (as hal-admin)
```bash
# Google Calendar service account JSON (download from Google Cloud Console)
cp /path/to/downloaded-service-account.json ~/credentials/calendar-service-account.json

# SSH deploy keys (generate on GitHub → repo → Settings → Deploy keys)
# id_snapjack = read-only access to Threadstone-Consulting/degen-poker
# id_dotfiles = read-write access to luk4s369/dotfiles
cp /path/to/id_snapjack ~/credentials/id_snapjack
cp /path/to/id_dotfiles ~/credentials/id_dotfiles

# GitHub PAT (generate at github.com → Settings → Developer settings → Personal access tokens)
echo "ghp_your_token_here" > ~/credentials/github-token.txt

# Lock down
chmod 600 ~/credentials/*
chown hal-admin:hal-admin ~/credentials/*
```

### Step 3: Install scripts (as hal-admin)
```bash
# Copy from vault (or dotfiles repo)
sudo cp /home/hal/.openclaw/workspace/Projects/security/gcal.sh ~/scripts/
sudo cp /home/hal/.openclaw/workspace/Projects/security/gcal-helper.js ~/scripts/
sudo cp /home/hal/.openclaw/workspace/Projects/security/git-ops.sh ~/scripts/
sudo cp /home/hal/.openclaw/workspace/Projects/security/github-api.sh ~/scripts/
sudo cp /home/hal/.openclaw/workspace/Projects/security/check-env.sh ~/scripts/

sudo chown hal-admin:hal-admin ~/scripts/*
sudo chmod 750 ~/scripts/*.sh
sudo chmod 640 ~/scripts/gcal-helper.js

# Install Node dependencies for calendar
cd ~/scripts && npm init -y && npm install googleapis
```

### Step 4: Sudoers (as hal-admin with sudo)
```bash
sudo tee /etc/sudoers.d/hal-scripts << 'EOF'
hal ALL=(hal-admin) NOPASSWD: /home/hal-admin/scripts/gcal.sh *
hal ALL=(hal-admin) NOPASSWD: /home/hal-admin/scripts/git-ops.sh *
hal ALL=(hal-admin) NOPASSWD: /home/hal-admin/scripts/github-api.sh *
hal ALL=(hal-admin) NOPASSWD: /home/hal-admin/scripts/check-env.sh *
EOF
sudo chmod 440 /etc/sudoers.d/hal-scripts
sudo visudo -cf /etc/sudoers.d/hal-scripts  # should say "parsed OK"
```

### Step 5: Permissions for git repos (as hal-admin with sudo)
```bash
# hal-admin needs to traverse hal's home for git operations
sudo chmod 711 /home/hal

# hal-admin needs to write git metadata in hal's repos
sudo usermod -aG hal hal-admin
newgrp hal  # apply without logout
sudo chmod -R g+w /home/hal/dotfiles/.git
sudo chmod -R g+w /home/hal/snapjack-repo/.git

# hal-admin needs safe.directory exceptions
git config --global --add safe.directory /home/hal/dotfiles
git config --global --add safe.directory /home/hal/snapjack-repo
```

### Step 6: hal-admin SSH config (as hal-admin)
```bash
mkdir -p ~/.ssh
cat >> ~/.ssh/config << 'EOF'
Host github-dotfiles
  HostName github.com
  User git
  IdentityFile /home/hal-admin/credentials/id_dotfiles

Host github-snapjack
  HostName github.com
  User git
  IdentityFile /home/hal-admin/credentials/id_snapjack
EOF
chmod 600 ~/.ssh/config
```

### Step 7: Remove deploy keys from hal (as hal-admin with sudo)
```bash
sudo rm /home/hal/.ssh/id_snapjack /home/hal/.ssh/id_dotfiles
sudo rm /home/hal/.ssh/id_snapjack.pub /home/hal/.ssh/id_dotfiles.pub 2>/dev/null
# Keep hal's ~/.ssh/config — harmless, SSH requires user ownership
```

### Step 8: Remove GITHUB_TOKEN from workspace (as hal-admin with sudo)
```bash
sudo rm /home/hal/.openclaw/workspace/.env
```

### Step 9: SystemD override (as hal-admin with sudo)
```bash
sudo mkdir -p /etc/systemd/system/openclaw.service.d
sudo tee /etc/systemd/system/openclaw.service.d/sudo.conf << 'EOF'
[Service]
NoNewPrivileges=false
EOF
sudo systemctl daemon-reload
sudo systemctl restart openclaw
```

### Step 10: Verify (from hal's OpenClaw session)
```bash
# Should work:
sudo -u hal-admin /home/hal-admin/scripts/gcal.sh help
sudo -u hal-admin /home/hal-admin/scripts/github-api.sh GET /user

# Should fail (permission denied):
cat /home/hal-admin/credentials/github-token.txt
cat /home/hal-admin/credentials/calendar-service-account.json
```

## Google Calendar Specifics

- **Google account:** audemears@gmail.com
- **Calendar ID:** audemears@gmail.com (hardcoded in gcal-helper.js)
- **Service account:** created in Google Cloud Console → IAM → Service Accounts
- **Calendar shared** with service account email (Make changes to events permission)
- **API enabled:** Google Calendar API in the Cloud project

### Google Cloud Console Setup
1. Create project at [console.cloud.google.com](https://console.cloud.google.com)
2. Enable Google Calendar API (APIs & Services → Library)
3. Create service account (APIs & Services → Credentials → Create → Service Account)
4. Download JSON key (Service Account → Keys → Add Key → JSON)
5. Share calendar with service account email in Google Calendar settings

## Git Operations

### Deploy Key Host Aliases
The git-ops.sh script uses SSH host aliases that map to deploy keys:
- `github-snapjack` → uses `id_snapjack` (read-only)
- `github-dotfiles` → uses `id_dotfiles` (read-write)

### Usage
```bash
sudo -u hal-admin /home/hal-admin/scripts/git-ops.sh push dotfiles main
sudo -u hal-admin /home/hal-admin/scripts/git-ops.sh pull snapjack main
sudo -u hal-admin /home/hal-admin/scripts/git-ops.sh fetch snapjack
```

## Adding New Integrations

1. Place credential in `/home/hal-admin/credentials/` (600)
2. Write wrapper script → draft in `Projects/security/`, review, copy to `~/scripts/`
3. Add sudoers line to `/etc/sudoers.d/hal-scripts`
4. Test: hal can execute, hal cannot read credential

## Related
- [[Snapjack MOC]]
- [[Dotfiles MOC]]
- Source scripts: `Projects/security/` in vault
