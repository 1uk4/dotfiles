# OpenClaw Setup

> AI assistant running as a hardened systemd service on Linux

## Architecture

```
Telegram --> OpenClaw Gateway (hal:18789/ws, 18792/http) --> AI models
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

### 2. Configure OpenClaw (as hal)

```bash
su - hal

# Set gateway mode
openclaw config set gateway.mode local

# Run interactive setup for channels, models, etc.
openclaw configure
```

Select and configure:
- **Gateway** -- mode: `local`
- **Channels** -- Telegram bot token + allowlisted user ID
- **Model** -- API provider credentials

### 3. Environment variables

```bash
cp localenv.template ~/.localenv
vim ~/.localenv
```

Required in `~/.env` or `~/.localenv`:

```bash
OPENCLAW_TELEGRAM_BOT_TOKEN=your-bot-token
```

### 4. Start the service (as root)

```bash
systemctl start openclaw
systemctl status openclaw
```

### 5. Verify

```bash
# As hal
openclaw health
openclaw dashboard
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

Only your Telegram user ID can interact with the bot. Set during `openclaw configure` under Channels.

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
systemctl restart openclaw
```

**Dashboard unreachable**
- Gateway WebSocket is on `18789`, dashboard HTTP is on `18792`
- Check `ss -tlnp` to confirm ports are listening
- Check `journalctl -u openclaw -n 30 --no-pager` for errors

**Permission denied**
- Service runs as `hal` -- config must be owned by `hal`:
  ```bash
  chown -R hal:hal /home/hal/.openclaw
  chown hal:hal /home/hal/.env
  ```

## Files

| Path | Purpose |
|------|---------|
| `~/.openclaw/openclaw.json` | Main config (gitignored) |
| `~/.openclaw/agents/` | Agent workspaces |
| `~/.openclaw/identity/` | Device keys |
| `~/.env` | Secrets (bot tokens, API keys) |
| `dotfiles/installscripts/setup-openclaw.sh` | Installer script |
| `dotfiles/config/fail2ban/jail.local` | Fail2ban config |
| `dotfiles/bin/security-audit` | Security audit script |
| `/etc/systemd/system/openclaw.service` | Systemd unit file |
