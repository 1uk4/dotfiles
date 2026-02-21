#!/usr/bin/env bash

# setup-openclaw.sh
# Sets up OpenClaw with security hardening on macOS or Linux.
# - Creates dedicated non-root user
# - Installs OpenClaw
# - Configures UFW firewall
# - Installs fail2ban
# - Sets up security audit script
#
# Run as root on Linux. On macOS, only installs OpenClaw (no hardening).

source ./installscripts/shell-variables.sh

OPENCLAW_USER="hal"
OPENCLAW_HOME="/home/${OPENCLAW_USER}"

# ──────────────────────────────────────────────
# User Setup
# ──────────────────────────────────────────────
create_user() {
  if id "$OPENCLAW_USER" &>/dev/null; then
    info "User '$OPENCLAW_USER' already exists."
  else
    info "Creating user '$OPENCLAW_USER'..."
    useradd -m -s /bin/bash "$OPENCLAW_USER"
    # No sudo access — principle of least privilege
    info "User '$OPENCLAW_USER' created (no sudo)."
  fi
}

# ──────────────────────────────────────────────
# Node.js Check
# ──────────────────────────────────────────────
check_node() {
  if ! command -v node &>/dev/null; then
    echo "Error: Node.js is required. Install it first (nvm, brew, or apt)."
    exit 1
  fi

  NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
  if [ "$NODE_VERSION" -lt 18 ]; then
    echo "Error: Node.js 18+ required. Current: $(node -v)"
    exit 1
  fi
}

# ──────────────────────────────────────────────
# OpenClaw Install
# ──────────────────────────────────────────────
install_openclaw() {
  if ! command -v openclaw &>/dev/null; then
    info "Installing OpenClaw via npm..."
    npm install -g openclaw
  else
    info "OpenClaw already installed: $(openclaw --version 2>/dev/null || echo 'installed')"
  fi

  # Create workspace as the openclaw user
  if [ ! -d "${OPENCLAW_HOME}/.openclaw/workspace" ]; then
    info "Creating workspace at ${OPENCLAW_HOME}/.openclaw/workspace/"
    sudo -u "$OPENCLAW_USER" mkdir -p "${OPENCLAW_HOME}/.openclaw/workspace"
  fi
}

# ──────────────────────────────────────────────
# UFW Firewall
# ──────────────────────────────────────────────
setup_firewall() {
  info "Configuring UFW firewall..."

  if ! command -v ufw &>/dev/null; then
    apt-get update -qq && apt-get install -y -qq ufw
  fi

  # Default: deny all incoming, allow all outgoing
  ufw default deny incoming
  ufw default allow outgoing

  # Allow SSH (keep access in case we need it later)
  ufw allow ssh

  # Enable (non-interactive)
  echo "y" | ufw enable

  info "UFW active. Policy: deny incoming, allow outgoing, allow SSH."
  ufw status verbose
}

# ──────────────────────────────────────────────
# Fail2ban
# ──────────────────────────────────────────────
setup_fail2ban() {
  info "Configuring fail2ban..."

  if ! command -v fail2ban-server &>/dev/null; then
    apt-get update -qq && apt-get install -y -qq fail2ban
  fi

  # Custom jail config
  JAIL_LOCAL="/etc/fail2ban/jail.local"
  if [ ! -f "$JAIL_LOCAL" ] || ! grep -q "openclaw" "$JAIL_LOCAL" 2>/dev/null; then
    cp "${DOTFILES}/config/fail2ban/jail.local" "$JAIL_LOCAL"
    info "Installed fail2ban jail config."
  else
    info "fail2ban jail.local already configured."
  fi

  systemctl enable fail2ban
  systemctl restart fail2ban

  info "fail2ban active."
}

# ──────────────────────────────────────────────
# Security Audit Script
# ──────────────────────────────────────────────
install_audit_script() {
  info "Installing security-audit script to ${DOTFILES}/bin/"
  chmod +x "${DOTFILES}/bin/security-audit"
  info "Run 'security-audit' anytime to check system security."
}

# ──────────────────────────────────────────────
# IPv6 Fix (Linux)
# ──────────────────────────────────────────────
# Many consumer routers (Google Wifi, etc.) advertise IPv6 ULA addresses
# without providing actual IPv6 internet connectivity. Node.js 22+ tries
# IPv6 first (autoSelectFamily), and when it can't route to the internet
# over IPv6, outbound connections (like Telegram API) fail or timeout.
#
# This is especially problematic on laptops that move between networks,
# since some networks have working IPv6 and some don't.
#
# Fix: disable IPv6 at both the sysctl and NetworkManager level to ensure
# Node.js always uses IPv4.
setup_disable_ipv6() {
  info "Disabling IPv6 (prevents Node.js connection failures on networks without full IPv6)..."

  # Sysctl: kernel-level IPv6 disable (baseline, but NetworkManager can override)
  SYSCTL_CONF="/etc/sysctl.d/99-disable-ipv6.conf"
  cat > "$SYSCTL_CONF" <<EOF
# Disable IPv6 — many networks advertise IPv6 ULA addresses without
# actual IPv6 internet connectivity, causing Node.js connection failures.
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
EOF
  /sbin/sysctl --system > /dev/null 2>&1
  info "sysctl IPv6 disabled."

  # NetworkManager: disable IPv6 on all existing connection profiles.
  # The sysctl alone is NOT enough — NetworkManager manages connections
  # independently and will re-enable IPv6 per-interface regardless of sysctl.
  # We must modify each connection profile directly via nmcli.
  if command -v nmcli &>/dev/null; then
    # Also drop a conf file for any connections created outside nmcli
    NM_CONF="/etc/NetworkManager/conf.d/disable-ipv6.conf"
    mkdir -p "$(dirname "$NM_CONF")"
    cat > "$NM_CONF" <<EOF
# Disable IPv6 on all NetworkManager connections.
# Prevents routers from assigning IPv6 addresses that can't route to the internet.
[connection]
ipv6.method=disabled
EOF

    # Disable IPv6 on every existing connection profile
    while IFS=: read -r name uuid type device; do
      name="$(echo "$name" | xargs)"  # trim whitespace
      if [ -n "$name" ] && [ "$name" != "NAME" ]; then
        nmcli connection modify "$name" ipv6.method disabled 2>/dev/null && \
          info "  IPv6 disabled on connection: $name"
      fi
    done < <(nmcli -t -f NAME,UUID,TYPE,DEVICE connection show)

    # Reconnect active WiFi/ethernet to apply immediately
    ACTIVE_CONN="$(nmcli -t -f NAME,DEVICE connection show --active | head -1 | cut -d: -f1)"
    if [ -n "$ACTIVE_CONN" ]; then
      nmcli connection down "$ACTIVE_CONN" 2>/dev/null
      nmcli connection up "$ACTIVE_CONN" 2>/dev/null
      info "  Reconnected '$ACTIVE_CONN' with IPv6 disabled."
    fi

    info "NetworkManager IPv6 disabled on all connections."
  fi
}

# ──────────────────────────────────────────────
# Systemd Service (Linux)
# ──────────────────────────────────────────────
setup_systemd_service() {
  info "Setting up OpenClaw systemd service..."

  cat > /etc/systemd/system/openclaw.service <<EOF
[Unit]
Description=OpenClaw Gateway
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=${OPENCLAW_USER}
Group=${OPENCLAW_USER}
WorkingDirectory=${OPENCLAW_HOME}/.openclaw/workspace
EnvironmentFile=${OPENCLAW_HOME}/.env
ExecStart=$(which openclaw) gateway run
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=${OPENCLAW_HOME}/.openclaw ${OPENCLAW_HOME}/.ssh ${OPENCLAW_HOME}/dotfiles
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable openclaw
  info "OpenClaw service installed. Start with: systemctl start openclaw"
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
main() {
  title "Setting up OpenClaw"

  check_node

  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS: just install, no hardening
    info "macOS detected — installing OpenClaw only (no system hardening)."
    if ! command -v openclaw &>/dev/null; then
      npm install -g openclaw
    fi
    mkdir -p "$HOME/.openclaw/workspace"
    info "Done. Run: openclaw setup"
    return
  fi

  # Linux: full hardened setup
  if [ "$(id -u)" -ne 0 ]; then
    echo "Error: Run as root on Linux (sudo ./install.sh openclaw)"
    exit 1
  fi

  create_user
  install_openclaw
  setup_disable_ipv6
  setup_firewall
  setup_fail2ban
  install_audit_script
  setup_systemd_service

  echo ""
  info "═══════════════════════════════════════════"
  info "  OpenClaw installed and hardened."
  info "═══════════════════════════════════════════"
  info ""
  info "  User:      ${OPENCLAW_USER} (no sudo)"
  info "  Workspace: ${OPENCLAW_HOME}/.openclaw/workspace/"
  info "  Firewall:  deny incoming, allow outgoing"
  info "  Fail2ban:  active on SSH"
  info ""
  info "  Next steps:"
  info "    1. Add Telegram bot token to ${OPENCLAW_HOME}/.openclaw config"
  info "    2. Configure allowlist (only your Telegram ID)"
  info "    3. systemctl start openclaw"
  info ""
  info "  Run 'security-audit' to check system security."
  info "═══════════════════════════════════════════"
}

main
