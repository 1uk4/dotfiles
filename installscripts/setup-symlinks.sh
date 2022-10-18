#!/usr/bin/env bash

# Include Variables
source ./installscripts/shell-variables.sh

title "Creating symlinks"

for file in $(get_linkables) ; do
        target="$HOME/.$(basename "$file" '.symlink')"
if [ -e "$target" ]; then
	info "~${target#$HOME} already exists... Skipping."
else
	info "Creating symlink for $file"
        ln -s "$file" "$target"
fi
done

echo -e
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


