#!/bin/bash
# Git operations wrapper — runs as hal-admin
# Usage: sudo -u hal-admin /home/hal-admin/scripts/git-ops.sh <repo> <command> [args...]

set -euo pipefail

KEYS_DIR="/home/hal-admin/credentials"

CMD="${1:-help}"
shift || true

# Map repo aliases to deploy keys and paths
get_repo_config() {
  case "$1" in
    dotfiles)
      KEY="$KEYS_DIR/id_dotfiles"
      REPO_PATH="/home/hal/dotfiles"
      REMOTE_URL="git@github-dotfiles:luk4s369/dotfiles.git"
      ;;
    snapjack)
      KEY="$KEYS_DIR/id_snapjack"
      REPO_PATH="/home/hal/snapjack-repo"
      REMOTE_URL="git@github-snapjack:Threadstone-Consulting/degen-poker.git"
      ;;
    *)
      echo "Unknown repo: $1 (available: dotfiles, snapjack)" >&2
      exit 1
      ;;
  esac
}

run_git() {
  local repo="$1"
  shift
  get_repo_config "$repo"
  GIT_SSH_COMMAND="ssh -i $KEY -o StrictHostKeyChecking=accept-new" \
    git -C "$REPO_PATH" "$@"
}

case "$CMD" in
  push)
    # Args: <repo> [branch]
    REPO="${1:?Usage: git-ops.sh push <repo> [branch]}"
    BRANCH="${2:-main}"
    run_git "$REPO" push origin "$BRANCH"
    ;;
  pull)
    # Args: <repo> [branch]
    REPO="${1:?Usage: git-ops.sh pull <repo> [branch]}"
    BRANCH="${2:-main}"
    run_git "$REPO" pull origin "$BRANCH"
    ;;
  fetch)
    # Args: <repo>
    REPO="${1:?Usage: git-ops.sh fetch <repo>}"
    run_git "$REPO" fetch origin
    ;;
  clone)
    # Args: <repo> <dest>
    REPO="${1:?Usage: git-ops.sh clone <repo> <dest>}"
    DEST="${2:?Usage: git-ops.sh clone <repo> <dest>}"
    get_repo_config "$REPO"
    GIT_SSH_COMMAND="ssh -i $KEY -o StrictHostKeyChecking=accept-new" \
      git clone "$REMOTE_URL" "$DEST"
    ;;
  help)
    echo "Commands: push <repo> [branch], pull <repo> [branch], fetch <repo>, clone <repo> <dest>"
    echo "Repos: dotfiles (read-write), snapjack (read-only)"
    ;;
  *)
    echo "Unknown command: $CMD" >&2
    exit 1
    ;;
esac
