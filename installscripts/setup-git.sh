#!/usr/bin/env bash

# Include Variables
source ./installscripts/shell-variables.sh


title "Setting up Git"

defaultName=$(git config user.name)
defaultEmail=$(git config user.email)
defaultGithub=$(git config github.user)

read -rp "Name [$defaultName] " name
read -rp "Email [$defaultEmail] " email
read -rp "Github username [$defaultGithub] " github

git config -f ~/.gitconfig-local user.name "${name:-$defaultName}"
git config -f ~/.gitconfig-local user.email "${email:-$defaultEmail}"
git config -f ~/.gitconfig-local github.user "${github:-$defaultGithub}"

if [[ "$(uname)" == "Darwin" ]]; then
	git config --global credential.helper "osxkeychain"
else
	read -rn 1 -p "Save user and password to an unencrypted file to avoid writing? [y/N] " save

	if [[ $save =~ ^([Yy])$ ]]; then
		git config --global credential.helper "store"
	else
		git config --global credential.helper "cache --timeout 3600"
	fi
fi
