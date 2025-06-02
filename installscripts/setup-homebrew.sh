#!/usr/bin/env bash

# setup-homebrew.sh
# This script installs Homebrew, brew dependencies, fzf, and NVM.
#
# Prerequisites:
# - curl must be installed
# - ./installscripts/shell-variables.sh must exist and define the "title" and "info" functions

# Include variables
source ./installscripts/shell-variables.sh


title "Setting up Homebrew"  

# Function to install Homebrew
install_homebrew() {
	if ! command -v brew >/dev/null; then
		info "Homebrew not installed. Installing."
		# Run as a login shell (non-interactive) so that the script doesn't pause for user input
		curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
	fi
}

# Function to set up Homebrew on Linux
setup_linux_homebrew() {
	if [[ "$(uname)" == "Linux" ]]; then
		test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
		test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		test -r ~/.bash_profile && echo "eval \"$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
	fi
}

# Function to install fzf
install_fzf() {
	info "Installing fzf"
	"$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

# Function to install NVM
install_nvm() {
	info "Installing NVM"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash  
}

# Main function 
main() {
	install_homebrew
	setup_linux_homebrew
	brew bundle
	install_fzf
	install_nvm
}

# Run the main function
main
