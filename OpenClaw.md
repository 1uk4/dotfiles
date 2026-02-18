# OpenClaw Setup

> AI assistant running as a hardened systemd service on Linux

## Architecture

```
Telegram --> OpenClaw Gateway (hal:18789/ws, 18792/http) --> Anthropic API
                    |
              systemd service
              user: hal (no sudo)
              UFW + fail2ban
```

## Quick Start

### 1. Run the installer (as root)

```bash
cd ~/dotfiles
./install.sh openclaw
```

This creates the `hal` user, installs OpenClaw, configures UFW/fail2ban, and sets up the systemd service.

### 2. Set up the service file (as root)

The installer creates the service, but ensure it has `EnvironmentFile` so the gateway can read secrets:

```ini
# /etc/systemd/system/openclaw.service
[Service]
EnvironmentFile=/home/hal/.env
ExecStart=/usr/bin/openclaw gateway run
User=hal
```

**Important:** The ExecStart command is `openclaw gateway run` (not `gateway start --foreground`).

```bash
systemctl daemon-reload
systemctl enable openclaw
```

### 3. Configure gateway (as hal)

```bash
su - hal

# Set gateway mode (required, or gateway won't start)
openclaw config set gateway.mode local
```

### 4. Add Telegram channel

```bash
openclaw channels add --channel telegram --token YOUR_BOT_TOKEN
```

Or use `--use-env` if `OPENCLAW_TELEGRAM_BOT_TOKEN` is in `~/.env`.

### 5. Set up Anthropic auth

```bash
openclaw models auth paste-token --provider anthropic
```

Paste your full API/OAuth token as a single line (tokens starting with `sk-ant-oat01-` are long -- make sure it doesn't get split across lines).

### 6. Start the service (as root)

```bash
systemctl start openclaw
systemctl status openclaw
```

### 7. Pair Telegram

Send any message to your bot on Telegram. The bot will reply with a pairing code. Approve it from a **separate terminal**:

```bash
openclaw devices approve PAIRING_CODE
```

To find your Telegram user ID, message `@userinfobot` on Telegram.

### 8. Verify

```bash
openclaw health
openclaw channels status
openclaw dashboard
```

Dashboard opens at `http://127.0.0.1:18792` (not 18789, which is WebSocket).

## Environment Variables

`~/.env` (owned by `hal:hal`, chmod 600):

```bash
OPENCLAW_TELEGRAM_BOT_TOKEN=your-bot-token
CLAUDE_CODE_OAUTH_TOKEN=your-claude-code-token
```

## Service Management

```bash
# Start/stop/restart (as root)
systemctl start openclaw
systemctl stop openclaw
systemctl restart openclaw

# Logs
journalctl -u openclaw -f

# Status
systemctl status openclaw
```

## Systemd Service

Located at `/etc/systemd/system/openclaw.service`:

- Runs as `hal` (no root)
- `EnvironmentFile=/home/hal/.env` -- loads secrets
- `ProtectSystem=strict` -- read-only filesystem except `~/.openclaw`
- `NoNewPrivileges=true` -- cannot escalate privileges
- `PrivateTmp=true` -- isolated temp directory
- Auto-restarts on failure

## Security

### Firewall (UFW)

- Default deny incoming, allow outgoing
- SSH allowed
- Config: `config/fail2ban/jail.local`

### Fail2ban

- SSH jail enabled: 3 attempts, 1 hour ban
- Monitors `/var/log/auth.log`

### Telegram Allowlist

Only your Telegram user ID can interact with the bot. Configured during pairing approval.

### Audit

```bash
security-audit
```

Checks: failed SSH logins, fail2ban bans, UFW status, listening ports, OpenClaw process user, disk/memory usage.

## Ports

| Port  | Protocol  | Purpose            |
|-------|-----------|--------------------|
| 18789 | WebSocket | Gateway API        |
| 18792 | HTTP      | Dashboard / Web UI |

## Troubleshooting

**Gateway won't start -- "Missing config"**
```bash
openclaw config set gateway.mode local
# then restart as root
systemctl restart openclaw
```

**"unknown option '--foreground'"**
- The systemd ExecStart must use `openclaw gateway run`, not `gateway start --foreground`

**Dashboard unreachable at 127.0.0.1:18789**
- That's the WebSocket port. Dashboard is on `18792`
- Check `ss -tlnp` to confirm both ports are listening

**"device token mismatch"**
- Delete the stale identity and restart:
  ```bash
  rm ~/.openclaw/identity/device.json
  # restart as root
  systemctl restart openclaw
  ```

**"No API key found for provider anthropic"**
- Auth is per-agent. Run:
  ```bash
  openclaw models auth paste-token --provider anthropic
  ```
- Paste the full token as one line (no line breaks)
- Restart the service after

**Telegram pairing code not working**
- Run the approve command from a **separate terminal** (not the one running claude/openclaw)
- Pairing codes expire -- send a new message to get a fresh code
- The full command is `openclaw devices approve CODE`

**Permission denied on config/env**
- Service runs as `hal` -- everything must be owned by `hal`:
  ```bash
  chown -R hal:hal /home/hal/.openclaw
  chown hal:hal /home/hal/.env
  chmod 600 /home/hal/.env
  ```

**"Unknown channel: telegram" when adding**
- Check `openclaw plugins list` -- Telegram plugin must show as `loaded`
- If disabled: `openclaw plugins enable telegram`

## Files

| Path | Purpose |
|------|---------|
| `~/.openclaw/openclaw.json` | Main config (gitignored) |
| `~/.openclaw/agents/main/agent/auth-profiles.json` | API keys per agent (gitignored) |
| `~/.openclaw/identity/device.json` | Device keypair (gitignored) |
| `~/.env` | Secrets (bot tokens, OAuth tokens) |
| `dotfiles/installscripts/setup-openclaw.sh` | Installer script |
| `dotfiles/config/fail2ban/jail.local` | Fail2ban config |
| `dotfiles/bin/security-audit` | Security audit script |
| `/etc/systemd/system/openclaw.service` | Systemd unit file |
