#!/usr/bin/env bash

# setup-symlinks.sh
# This script creates symlinks from the home directory to dotfiles in the repo.
# It also creates symlinks for config files in the ~/.config directory.
#
# Prerequisites:
# - ./installscripts/shell-variables.sh must exist and define the "title", "info", and "get_linkables" functions
# - $DOTFILES environment variable must be set

# Include variables
source ./installscripts/shell-variables.sh

# Function to create symlinks for dotfiles
create_dotfile_symlinks() {
    for file in $(get_linkables); do
        target="$HOME/.$(basename "$file" '.symlink')"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $file"
            ln -s "$file" "$target"
        fi
    done
}

# Function to create symlinks for config files
create_config_symlinks() {
    info "installing to ~/.config"

    if [ ! -d "$HOME/.config" ]; then
        info "Creating ~/.config"
        mkdir -p "$HOME/.config"
    fi

    config_files=$(find "$DOTFILES/config" -maxdepth 1 2>/dev/null)

    for config in $config_files; do
        target="$HOME/.config/$(basename "$config")"
        if [ -e "$target" ]; then
            info "~${target#$HOME} already exists... Skipping."
        else
            info "Creating symlink for $config"
            ln -s "$config" "$target"
        fi
    done
}

# Main function
main() {
    title "Creating symlinks"
    
    create_dotfile_symlinks
    echo -e
    create_config_symlinks
}

# Run the main function
main

