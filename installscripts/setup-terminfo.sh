#!/usr/bin/env bash

# Include Variables
source ./installscripts/shell-variables.sh


title "Configuring terminfo"

info "adding tmux.terminfo"
tic -x "$DOTFILES/resources/tmux.terminfo"

info "adding xterm-256color-italic.terminfo"
tic -x "$DOTFILES/resources/xterm-256color-italic.terminfo"




