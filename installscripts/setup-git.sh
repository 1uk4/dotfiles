#!/usr/bin/env bash

# setup-git.sh
# This script configures git with the user's name, email, and GitHub username.
# It also sets up the appropriate git credential helper based on the platform.
#
# Prerequisites:
# - git must be installed
# - ./installscripts/shell-variables.sh must exist and define the "title" function

# Include variables
source ./installscripts/shell-variables.sh

# Function to configure git credential helper on macOS
configure_macos_credential_helper() {
  git config --global credential.helper "osxkeychain"
}

# Function to configure git credential helper on Linux/other platforms
configure_other_credential_helper() {
  read -rp "Save user and password to an unencrypted file to avoid writing? [y/N] " save_credentials

  if [[ $save_credentials =~ ^([Yy])$ ]]; then
    git config --global credential.helper "store"
  else
    git config --global credential.helper "cache --timeout 3600"
  fi
}

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

  if [[ "$(uname)" == "Darwin" ]]; then
    configure_macos_credential_helper
  else
    configure_other_credential_helper
  fi
}

# Run the main function
main
