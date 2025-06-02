#!/usr/bin/env bash

 #setup#-hosts.sh
# This script optionally replaces the /etc/hosts file with a version that includes ad-blocking entries.
#
# Prerequisites:
# - ./installscripts/shell-variables.sh must exist and define the "title" function
# - ./resources/hosts/host file must exist

# Include variables
source ./installscripts/shell-variables.sh


title "Setting Host File"


# Function to set up the hosts file
setup_hosts_file() {
    read -e -s -n 1 -p "Ad-blocking hosts file from someonewhocares.org? [Press Enter to Continue...] " response 

    if [[ $response = "" ]]; then 
        echo -e "Linking New Hosts files (resources/hosts/host)"
        sudo rm -r /etc/hosts
        sudo ln -s ./resources/hosts/host /etc/hosts
        echo -e "Your /etc/hosts file has been updated. Last version is saved in /etc/hosts.backup"
    else
        echo "skipped";
    fi
}

# Main function
main() {
    setup_hosts_file
}

# Run the main function
main
