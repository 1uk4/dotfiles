#!/usr/bin/env bash

# Include Variables
source ./installscripts/shell-variables.sh


title "Setting Host File"


# Customize Host file (from ./resources/hosts/hosts) 
read -e -s -n 1 -p "Ad-blocking hosts file from someonewhocares.org? [Press Enter to Continue...] " response 

if [[ $response = "" ]]; then 
    echo -e "Linking New Hosts files (resources/hosts/host)"
    sudo rm -r /etc/hosts
    sudo ln -s ./resources/hosts/host /etc/hosts
    echo -e "Your /etc/hosts file has been updated. Last version is saved in /etc/hosts.backup"
else
    echo "skipped";
fi
