#!/usr/bin/env bash

# setup-shell.sh
# This script configures zsh as the default shell.
#
# Prerequisites:
# - ./installscripts/shell-variables.sh must exist and define the "title" and "info" functions
# - zsh must be installed

# Include variables
source ./installscripts/shell-variables.sh

# Function to set zsh as the default shell
configure_zsh_shell() {
    # Determine the path to zsh, preferring the Homebrew version if available
    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"

    # Add zsh to /etc/shells if it's not already there
    if ! grep "$zsh_path" /etc/shells; then
        info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    # Change the default shell to zsh if it's not already
    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        info "default shell changed to $zsh_path"
    fi
}

# Main function
main() {
    title "Configuring shell"
    configure_zsh_shell
}

# Run the main function
main
