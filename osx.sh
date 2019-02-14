#!/bin/bash

step() {
  echo -e "\x1B[34m==>\x1B[0m \x1B[1m$1\x1B[0m"
}

step "Enable full keyboard access for all controls"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

step "Enable subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

step "Enable the 2D dock"
defaults write com.apple.dock no-glass -bool true

step "Automatically hide the dock"
defaults write com.apple.dock autohide -bool true

step "Disable menu bar transparency"
defaults write -g AppleEnableMenuBarTransparency -bool false

step "Expand save panel by default"
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true

step "Expand print panel by default"
defaults write -g PMPrintingExpandedStateForPrint -bool true

step "Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

step "Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

step "Set initial key repeat delay to 150ms (normal minimum is 225ms)"
defaults write NSGlobalDomain InitialKeyRepeat -int 10

step "Set key repeat reate to 15ms (normal minimum is 30ms)"
defaults write NSGlobalDomain KeyRepeat -int 1

step "Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

step "Disable window animations"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

step "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

step "Auto-open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

step "Disable writing .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

step "Disable Safari's thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

step "Enable Safari's debug menu"
defaults write com.apple.Safari IncludeDebugMenu -bool true

step "Remove useless icons from Safari's bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar '()'

step "Disable send and reply animations in Mail.app"
defaults write com.apple.Mail DisableReplyAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true

step "Disable Resume system-wide"
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

step "Show all filename extensions in Finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

step "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

step "Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

step "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

step "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

step "Enable tap to click (Trackpad)"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

step "Show the ~/Library folder"
chflags nohidden ~/Library

step "Kill affected applications"
for app in Safari Finder Dock Mail; do killall "$app" 2>/dev/null; done
