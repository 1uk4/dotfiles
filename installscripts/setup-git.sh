#!/usr/bin/env bash

# setup-git.sh
# This script configures git with the user's name, email, and GitHub username.
# It also sets up the appropriate git credential helper based on the platform.

# Include variables
source ./installscripts/shell-variables.sh

# Main function
main() {
  title "Setting up Git"

  default_name=$(git config user.name)
  default_email=$(git config user.email)
  default_github_username=$(git config github.user)

  read -rp "Enter your name [$default_name]: " name
  read -rp "Enter your email [$default_email]: " email
  read -rp "Enter your GitHub username [$default_github_username]: " github_username

  git config -f ~/.gitconfig-local user.name "${name:-$default_name}"
  git config -f ~/.gitconfig-local user.email "${email:-$default_email}"
  git config -f ~/.gitconfig-local github.user "${github_username:-$default_github_username}"

  # Credential helper: keychain on macOS, cache on Linux (never plaintext)
  if [[ "$(uname)" == "Darwin" ]]; then
    git config --global credential.helper "osxkeychain"
  else
    git config --global credential.helper "cache --timeout 3600"
  fi

  # Security hardening
  git config --global transfer.fsckObjects true
  git config --global fetch.fsckObjects true
  git config --global receive.fsckObjects true
}

main
