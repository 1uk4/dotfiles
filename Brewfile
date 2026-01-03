# Brewfile - Complete macOS Environment Setup
# Run: brew bundle install

# Taps
tap "homebrew/bundle"
tap "homebrew/cask-fonts"
tap "charmbracelet/tap"
tap "zegervdv/zathura"

if OS.mac?
    # macOS specific
    brew "trash" # rm to trash instead of delete

elsif OS.linux?
    brew "xclip" # clipboard access (like pbcopy/pbpaste)
end

# =============================================================================
# CLI Tools
# =============================================================================

# Core utilities
brew "bat"              # better cat
brew "fd"               # better find
brew "ripgrep"          # better grep
brew "fzf"              # fuzzy finder
brew "zoxide"           # smarter cd (replaces z)
brew "jq"               # JSON processor
brew "htop"             # process viewer
brew "wget"             # file downloader
brew "grep"             # grep (latest)

# Development
brew "git"              # version control
brew "git-delta"        # better git diff
brew "git-lfs"          # large file storage
brew "gh"               # GitHub CLI
brew "lazygit"          # git TUI
brew "neovim"           # editor
brew "vim"              # backup editor
brew "gcc"              # C/C++ compiler
brew "python"           # Python (latest)
brew "bun"              # fast JS runtime

# AI/Coding
brew "opencode"         # AI coding assistant
brew "charmbracelet/tap/crush"  # AI terminal assistant

# Productivity
brew "tmuxinator"       # tmux session manager
brew "entr"             # file watcher
brew "cloc"             # count lines of code
brew "nmap"             # network scanner

# Media
brew "ffmpeg"           # video/audio processing
brew "yt-dlp"           # youtube downloader
brew "fswatch"          # file system watcher (for inkscape)
brew "highlight"        # syntax highlighting

# Documents
brew "zegervdv/zathura/zathura-pdf-poppler"  # PDF viewer

# Other
brew "gnupg"            # GPG encryption
brew "neofetch"         # system info
brew "zsh"              # shell

# =============================================================================
# Applications (Casks)
# =============================================================================

# Terminals
cask "kitty"            # primary terminal
cask "alacritty"        # backup terminal
cask "iterm2"           # backup terminal

# Development
cask "docker-desktop"   # containers
cask "visual-studio-code"
cask "postman"          # API testing
cask "kubecontext"      # K8s context switcher

# Productivity
cask "raycast"          # launcher (spotlight replacement)
cask "rectangle"        # window management
cask "obsidian"         # notes/PKM
cask "numi"             # calculator
cask "stats"            # system stats in menu bar
cask "appcleaner"       # clean uninstalls
cask "imageoptim"       # image compression
cask "ccleaner"         # system cleaner
cask "marked"           # markdown preview

# Browsers
cask "google-chrome"
cask "zen-browser"      # privacy browser
cask "tor-browser"      # anonymity browser
cask "ungoogled-chromium"  # de-googled chrome

# Communication
cask "discord"
cask "telegram-desktop"

# Privacy/Security
cask "protonvpn"        # VPN
cask "lulu"             # firewall
cask "lockdown"         # privacy
cask "onionshare"       # anonymous sharing
cask "keepassxc"        # password manager

# Media/Creative
cask "spotify"
cask "rekordbox"        # DJ software
cask "inkscape"         # vector graphics
cask "calibre"          # ebook management

# Utilities
cask "balenaetcher"     # flash USB drives
cask "mathpix-snipping-tool"  # math OCR
cask "bisq"             # crypto
cask "anaconda"         # Python distribution
cask "karabiner-elements"  # keyboard customization

# Fonts
cask "font-hack-nerd-font"
cask "font-jetbrains-mono"
cask "font-fira-code"
cask "font-cascadia-mono"
cask "font-3270-nerd-font"
