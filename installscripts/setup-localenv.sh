#!/usr/bin/env bash

# setup-localenv.sh
# This script sets up a .localenv file in the user's home directory for storing sensitive information.
#
# Prerequisites:
# - ./installscripts/shell-variables.sh must exist and define the "title", "warning", "info", "success", and "error" functions
# - $DOTFILES/localenv.template file must exist

# Include variables
source ./installscripts/shell-variables.sh

# Function to set up the .localenv file
setup_localenv() {
    title "Setting up local environment variables"
    
    # Check if .localenv already exists in the home directory
    if [ -f "$HOME/.localenv" ]; then
        warning "A .localenv file already exists in your home directory."
        read -p "Do you want to overwrite it? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            info "Keeping your existing .localenv file."
            return
        fi
    fi
    
    # Copy the template file to the home directory
    if [ -f "$DOTFILES/localenv.template" ]; then
        cp "$DOTFILES/localenv.template" "$HOME/.localenv"
        success "Created .localenv file in your home directory."
        info "Please edit ~/.localenv to add your API keys and other sensitive information."
        info "You can do this by running: vim ~/.localenv"
    else
        error "localenv.template file not found in $DOTFILES. Please create it first."
    fi
}

# Main function
main() {
    setup_localenv
}

# Run the main function
main

