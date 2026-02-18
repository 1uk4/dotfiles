#!/usr/bin/env bash

# setup-openclaw.sh
# Installs and configures OpenClaw on macOS or Linux.
# Requires Node.js (v18+) to be installed.

source ./installscripts/shell-variables.sh

main() {
  title "Setting up OpenClaw"

  # Check for Node.js
  if ! command -v node &> /dev/null; then
    echo "Error: Node.js is required. Install it first (nvm, brew, or apt)."
    exit 1
  fi

  NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
  if [ "$NODE_VERSION" -lt 18 ]; then
    echo "Error: Node.js 18+ required. Current: $(node -v)"
    exit 1
  fi

  # Install openclaw globally if not present
  if ! command -v openclaw &> /dev/null; then
    info "Installing OpenClaw via npm..."
    npm install -g openclaw
  else
    info "OpenClaw already installed: $(openclaw --version 2>/dev/null || echo 'unknown version')"
  fi

  # Create workspace directory
  if [ ! -d "$HOME/.openclaw/workspace" ]; then
    info "Creating ~/.openclaw/workspace/"
    mkdir -p "$HOME/.openclaw/workspace"
  fi

  # Platform-specific notes
  if [[ "$(uname)" == "Linux" ]]; then
    info "Linux detected."
    info "To keep the machine always-on (laptop), consider:"
    info "  - Set HandleLidSwitch=ignore in /etc/systemd/logind.conf"
    info "  - Run: systemctl mask sleep.target suspend.target hibernate.target"
  fi

  echo ""
  info "OpenClaw installed. Next steps:"
  info "  1. Add your Telegram bot token to ~/.localenv"
  info "  2. Run: openclaw setup"
  info "  3. Run: openclaw gateway start"
  echo ""
  info "Docs: https://docs.openclaw.ai"
}

main
