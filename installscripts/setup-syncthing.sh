#!/usr/bin/env bash

# setup-syncthing.sh
# Sets up Syncthing to sync the OpenClaw workspace (Obsidian vault) across devices.
#
# What it does:
#   - Installs Syncthing
#   - Creates ~/hal-mind symlink → ~/.openclaw/workspace/
#   - Copies .stignore to exclude node_modules, .git, .obsidian, etc.
#   - Enables Syncthing as a background service
#   - Prints device ID for manual pairing
#
# Prerequisites:
#   - OpenClaw must be installed first (setup-openclaw.sh)
#   - ~/.openclaw/workspace/ must exist
#
# After running:
#   1. Open Syncthing web UI (http://localhost:8384)
#   2. Add a shared folder pointing to ~/hal-mind
#   3. Pair other devices using the printed device ID
#   4. On other devices, point Obsidian at the synced folder

source ./installscripts/shell-variables.sh

OPENCLAW_USER="hal"
OPENCLAW_HOME="/home/${OPENCLAW_USER}"
WORKSPACE="${OPENCLAW_HOME}/.openclaw/workspace"
SYMLINK="${OPENCLAW_HOME}/hal-mind"

# ──────────────────────────────────────────────
# Install Syncthing
# ──────────────────────────────────────────────
install_syncthing() {
  if command -v syncthing &>/dev/null; then
    info "Syncthing already installed: $(syncthing --version 2>/dev/null | head -1)"
    return
  fi

  if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &>/dev/null; then
      info "Installing Syncthing via Homebrew..."
      brew install syncthing
    else
      error "Homebrew required on macOS. Install it first."
    fi
  else
    info "Installing Syncthing via apt..."
    apt-get update -qq && apt-get install -y -qq syncthing
  fi
}

# ──────────────────────────────────────────────
# Create symlink: ~/hal-mind → ~/.openclaw/workspace/
# ──────────────────────────────────────────────
# IMPORTANT: The real files MUST live at ~/.openclaw/workspace/
# because OpenClaw's sandbox only has write access to ~/.openclaw/.
# The symlink at ~/hal-mind is for Syncthing and human convenience.
# DO NOT reverse this — putting real files at ~/hal-mind breaks
# the agent's ability to write to the vault.
# ──────────────────────────────────────────────
create_symlink() {
  if [ ! -d "$WORKSPACE" ]; then
    error "OpenClaw workspace not found at $WORKSPACE. Run setup-openclaw.sh first."
  fi

  if [ -L "$SYMLINK" ]; then
    CURRENT_TARGET="$(readlink "$SYMLINK")"
    if [ "$CURRENT_TARGET" = "$WORKSPACE" ] || [ "$CURRENT_TARGET" = "${WORKSPACE}/" ]; then
      info "Symlink already exists: $SYMLINK → $WORKSPACE"
      return
    else
      warning "Symlink exists but points to $CURRENT_TARGET. Fixing..."
      rm "$SYMLINK"
    fi
  elif [ -d "$SYMLINK" ]; then
    warning "$SYMLINK is a real directory. If it contains files, move them to $WORKSPACE first."
    error "Cannot create symlink — $SYMLINK already exists as a directory."
  fi

  if [[ "$(uname)" == "Darwin" ]]; then
    ln -s "$HOME/.openclaw/workspace" "$HOME/hal-mind"
  else
    sudo -u "$OPENCLAW_USER" ln -s "$WORKSPACE" "$SYMLINK"
  fi
  info "Created symlink: $SYMLINK → $WORKSPACE"
}

# ──────────────────────────────────────────────
# Install .stignore (Syncthing ignore patterns)
# ──────────────────────────────────────────────
install_stignore() {
  STIGNORE="${WORKSPACE}/.stignore"

  if [ -f "$STIGNORE" ]; then
    info ".stignore already exists."
    return
  fi

  cat > "$STIGNORE" <<'EOF'
// Syncthing ignore patterns for OpenClaw workspace / Obsidian vault

// Obsidian internal config (each device has its own)
.obsidian

// Git repos inside projects
Projects/*/node_modules
Projects/*/.git
Projects/*/.next
Projects/*/dist
Projects/*/.turbo

// OpenClaw internal state
.openclaw
.pi

// OS junk
.DS_Store
Thumbs.db
*.swp
*~

// Environment files with secrets
.env
.env.local
.env.production
EOF

  if [[ "$(uname)" != "Darwin" ]]; then
    chown ${OPENCLAW_USER}:${OPENCLAW_USER} "$STIGNORE"
  fi
  info "Installed .stignore with default exclusions."
}

# ──────────────────────────────────────────────
# Enable Syncthing as a service
# ──────────────────────────────────────────────
enable_service() {
  if [[ "$(uname)" == "Darwin" ]]; then
    if command -v brew &>/dev/null; then
      brew services start syncthing 2>/dev/null
      if brew services info syncthing 2>/dev/null | grep -q "Running: ✔"; then
        info "Syncthing running via brew services."
      else
        warning "brew services failed to start Syncthing. Using nohup fallback."
        info "Add this to your shell profile for auto-start:"
        info "  nohup syncthing --no-browser > ~/Library/Logs/syncthing.log 2>&1 &"
        nohup syncthing --no-browser > ~/Library/Logs/syncthing.log 2>&1 &
        info "Syncthing started in background (PID: $!)"
      fi
    fi
  else
    info "Enabling Syncthing user service for $OPENCLAW_USER..."
    sudo -u "$OPENCLAW_USER" XDG_RUNTIME_DIR="/run/user/$(id -u $OPENCLAW_USER)" \
      systemctl --user enable syncthing 2>/dev/null
    sudo -u "$OPENCLAW_USER" XDG_RUNTIME_DIR="/run/user/$(id -u $OPENCLAW_USER)" \
      systemctl --user start syncthing 2>/dev/null
    info "Syncthing service enabled and started."
  fi
}

# ──────────────────────────────────────────────
# Print device ID for pairing
# ──────────────────────────────────────────────
print_device_id() {
  echo ""
  if [[ "$(uname)" == "Darwin" ]]; then
    DEVICE_ID=$(syncthing --device-id 2>/dev/null)
  else
    DEVICE_ID=$(sudo -u "$OPENCLAW_USER" syncthing --device-id 2>/dev/null)
  fi

  if [ -n "$DEVICE_ID" ]; then
    info "═══════════════════════════════════════════"
    info "  Device ID (copy this to pair other devices):"
    info ""
    info "  $DEVICE_ID"
    info ""
    info "═══════════════════════════════════════════"
  else
    warning "Could not retrieve device ID. Start Syncthing and check the web UI at http://localhost:8384"
  fi
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
main() {
  title "Setting up Syncthing (Obsidian vault sync)"

  if [[ "$(uname)" == "Darwin" ]]; then
    info "macOS detected."
    OPENCLAW_HOME="$HOME"
    WORKSPACE="$HOME/.openclaw/workspace"
    SYMLINK="$HOME/hal-mind"
  else
    if [ "$(id -u)" -ne 0 ]; then
      echo "Error: Run as root on Linux (sudo ./install.sh syncthing)"
      exit 1
    fi
  fi

  install_syncthing
  create_symlink
  install_stignore
  enable_service
  print_device_id

  echo ""
  info "═══════════════════════════════════════════"
  info "  Syncthing installed and configured."
  info "═══════════════════════════════════════════"
  info ""
  info "  Workspace:  $WORKSPACE (real files)"
  info "  Symlink:    $SYMLINK → workspace"
  info "  Web UI:     http://localhost:8384"
  info ""
  info "  Next steps:"
  info "    1. Open the web UI"
  info "    2. Add shared folder → path: $SYMLINK"
  info "    3. Pair other devices (swap device IDs)"
  info "    4. On other devices: install Syncthing + Obsidian"
  info "    5. Point Obsidian at the synced folder"
  info ""
  info "  Phone setup (iOS):"
  info "    1. Install Tailscale on iPhone, sign in to same tailnet"
  info "    2. Install Möbius Sync (~\$7) from App Store"
  info "    3. Add each device manually in Möbius Sync:"
  info "       - Debian: tcp://<debian-tailscale-ip>:22000"
  info "       - Mac:    tcp://<mac-tailscale-ip>:22000"
  info "    4. On Debian/Mac Syncthing, add the phone's device ID"
  info "       with address tcp://<phone-tailscale-ip>:22000"
  info "    5. Share hal-mind folder with the phone device"
  info "    6. Accept the folder share in Möbius Sync"
  info "    7. Install Obsidian on iPhone"
  info "    8. Create a new vault (iCloud OFF)"
  info "    9. In Möbius, set hal-mind sync path to the Obsidian vault folder"
  info "       (On My iPhone → Obsidian → <vault-name>)"
  info "   10. Install Dataview plugin in Obsidian mobile"
  info ""
  info "  Notes:"
  info "    - Global discovery is disabled; use Tailscale IPs for addresses"
  info "    - Möbius only syncs when the app is open (iOS limitation)"
  info "    - Android: use Syncthing (free) instead of Möbius Sync"
  info "═══════════════════════════════════════════"
}

main
