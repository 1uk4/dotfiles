#!/usr/bin/env bash

# setup-macos.sh
# This script configures various MacOS settings for a better user experience.
# Inspiration: https://wilsonmar.github.io/dotfiles/
#
# Prerequisites:
# - ./installscripts/shell-variables.sh must exist and define the "title" and "warning" functions
# - Must be running on MacOS

# Include variables
source ./installscripts/shell-variables.sh

# Function to configure Terminal settings
configure_terminal() {
    echo "Terminal "

    echo " - Only use UTF-8 in Terminal.app"
    defaults write com.apple.terminal StringEncodings -array 4

    echo " - Enable Secure Keyboard Entry in Terminal.app "
    # See: https://security.stackexchange.com/a/47786/8918
    defaults write com.apple.terminal SecureKeyboardEntry -bool true

    echo " - Don't display the annoying prompt when quitting iTerm "
    defaults write com.googlecode.iterm2 PromptOnQuit -bool false
}

# Function to configure App Store settings
configure_app_store() {
    echo "App Store"
    echo " - Enable automatic update check"
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

    echo " - Check for software updates daily, not just once per week"
    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
    
    echo " - Download newly available updates in background"
    defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

    echo " - Install System data files & security updates "
    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
    
    echo " - Turn on app auto-update"
    defaults write com.apple.commerce AutoUpdate -bool true

    echo " - Allow the App Store to reboot machine on macOS updates"
    defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
}

# Function to configure Photos settings
configure_photos() {
    echo "Photos"
    echo " - Prevent Photos from opening automatically when devices are plugged in "
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
}

# Function to configure Finder settings
configure_finder() {
    echo "Finder:"

    echo " - Expand save dialog by default"
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

    echo " - Show hidden files by default"
    defaults write com.apple.Finder AppleShowAllFiles -bool false

    echo " - Show all filename extensions"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    echo " - Use current directory as default search scope in Finder"
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    echo " - Show Path bar in Finder"
    defaults write com.apple.finder ShowPathbar -bool true

    echo " - Show Status bar in Finder"
    defaults write com.apple.finder ShowStatusBar -bool true
    
    echo " - Allow quitting via ⌘ + Q; doing so will also hide desktop icons"
    defaults write com.apple.finder QuitMenuItem -bool true

    echo " - Disable window animations and Get Info animations "
    defaults write com.apple.finder DisableAllAnimations -bool true
    
    echo " - Show the ~/Library folder in Finder"
    chflags nohidden ~/Library
    
    echo " - Show icons for hard drives, servers, and removable media on the desktop"
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    echo " - Disable the warning when changing a file extension"
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    echo " - Enable spring loading for directories"
    defaults write NSGlobalDomain com.apple.springing.enabled -bool true

    echo " - Remove the spring loading delay for directories"
    defaults write NSGlobalDomain com.apple.springing.delay -float 0
}

# Function to configure hardware settings
configure_hardware() {
    echo "Hardware: Keyboard - Screen"

    echo " - Enable subpixel font rendering on non-Apple LCDs"
    defaults write NSGlobalDomain AppleFontSmoothing -int 2

    echo " - Disable press-and-hold for keys in favor of key repeat"
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    echo " - Set a blazingly fast keyboard repeat rate"
    defaults write NSGlobalDomain KeyRepeat -float 20 

    echo " - Set a shorter Delay until key repeat"
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    echo " - Enable tap to click (Trackpad)"
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

    echo " - Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
}

# Function to configure Dock settings
configure_dock() {
    echo "Dock "
    echo " - Size (of icons on Dock): 36 pixels "
    defaults write com.apple.dock tilesize -int 36

    echo " - Disable Application Opening Animation"
    defaults write com.apple.dock launchanim -bool false

    echo " - Remove Auto-Hiding Dock Delay"
    defaults write com.apple.dock autohide-delay -float 0

    echo " - Remove the animation when hiding/showing the Dock "
    defaults write com.apple.dock autohide-time-modifier -float 0
}

# Function to clean up and restart affected applications
cleanup() {
    echo "Clean up "
    echo " - Kill affected applications"

    for app in "Activity Monitor" "Dock" "Finder" "SystemUIServer" "Terminal"; do
        killall "${app}" &> /dev/null
    done
}

# Main function
main() {
    title "Configuring MacOS"

    # If System is MacOS Then execute, Otherwise Skip
    if [[ "$(uname)" == "Darwin" ]]; then
        configure_terminal
        configure_app_store
        configure_photos
        configure_finder
        configure_hardware
        configure_dock
        cleanup
    else
        warning "MacOS not detected. Skipping."
    fi
}

# Run the main function
main

