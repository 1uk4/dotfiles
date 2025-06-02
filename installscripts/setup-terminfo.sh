#!/usr/bin/env bash

# setup-terminfo.sh
# This script configures terminfo entries for tmux and xterm-256color-italic.
#
# Prerequisites:
# - ./installscripts/shell-variables.sh must exist and define the "title" and "info" functions
# - $DOTFILES/resources/tmux.terminfo and $DOTFILES/resources/xterm-256color-italic.terminfo must exist
# - tic command must be available

# Include variables
source ./installscripts/shell-variables.sh

# Function to configure tmux terminfo
configure_tmux_terminfo() {
    info "adding tmux.terminfo"
    tic -x "$DOTFILES/resources/tmux.terminfo"
}

# Function to configure xterm-256color-italic terminfo
configure_xterm_terminfo() {
    info "adding xterm-256color-italic.terminfo"
    tic -x "$DOTFILES/resources/xterm-256color-italic.terminfo"
}

# Main function
main() {
    title "Configuring terminfo"
    configure_tmux_terminfo
    configure_xterm_terminfo
}

# Run the main function
main

