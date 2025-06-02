#!/usr/bin/env bash

# shell-variables.sh
# This script defines common variables and functions used by the install scripts.
#
# Variables:
# - DOTFILES: The path to the dotfiles repository
# - COLOR_*: ANSI color codes for terminal output
#
# Functions:
# - title: Display a section title
# - error: Display an error message and exit
# - warning: Display a warning message
# - info: Display an informational message
# - success: Display a success message
# - get_linkables: Find all symlink files in the dotfiles repository

DOTFILES="$(pwd)"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"



title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}
