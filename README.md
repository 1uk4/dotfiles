# Dotfiles

> A terminal-first development environment for macOS and Linux

## What's Included

| Category | Tools |
|----------|-------|
| **Shell** | Zsh + custom prompt, lazy-loaded NVM, zoxide, fzf |
| **Editor** | Neovim with LSP, Treesitter, Telescope, Harpoon |
| **Terminal** | Kitty (primary), Alacritty, iTerm2 |
| **Multiplexer** | Tmux with vim-style bindings |
| **Git** | Lazygit, git-delta, gitsigns |
| **AI** | OpenCode in Neovim + tmux, OpenClaw assistant |
| **Fonts** | Hack Nerd Font, JetBrains Mono, Fira Code |

## Quick Start

### Prerequisites

```sh
xcode-select --install
```

### Installation

```sh
# Clone
git clone https://github.com/1uk4/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install everything
./install.sh all

# Or see available options
./install.sh
```

### Post-Install

```sh
# Set up local environment variables (API keys, etc.)
cp localenv.template ~/.localenv
vim ~/.localenv

# Install Homebrew packages
brew bundle install

# Reload shell
source ~/.zshrc
```

## Key Bindings

### Tmux

**Prefix:** `Ctrl+a`

| Key | Action |
|-----|--------|
| `prefix + Tab` | Toggle between panes |
| `prefix + z` | Zoom pane fullscreen |
| `prefix + g` | Open Lazygit |
| `prefix + h/j/k/l` | Navigate panes |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + \|` | Split horizontal |
| `prefix + -` | Split vertical |

### Neovim

**Leader:** `Space`

| Key | Action |
|-----|--------|
| `<leader>pf` | Find files |
| `<leader>ps` | Grep search |
| `<C-e>` | Harpoon menu |
| `<leader>a` | Add to Harpoon |
| `gd` | Go to definition |
| `<leader>f` | Format file |
| `<leader>gs` | Git status |
| `<leader>y` | Yank to clipboard |

### IDE Mode

Launch Neovim + OpenCode side by side:

```sh
ide [file] [--vertical] [--size=30]
```

## Directory Structure

```
dotfiles/
├── bin/              # Custom scripts (added to PATH)
├── config/
│   ├── nvim/         # Neovim configuration
│   ├── kitty/        # Kitty terminal config
│   └── ...
├── tmux/             # Tmux configuration
├── zsh/              # Zsh configuration
├── installscripts/   # Setup scripts
├── Brewfile          # Homebrew packages
└── install.sh        # Main installer
```

## Customization

### Local Overrides

- `~/.zshrc.local` - Local shell customizations (not tracked)
- `~/.localenv` - Environment variables & API keys (not tracked)

### Forking

1. Fork this repo
2. Search and replace existing username references with your own
3. Rename the `config/nvim/lua/` subdirectory to match your setup
4. Modify configurations to your liking

## Shell Features

- **Lazy NVM** - Node version manager loads on first use (faster startup)
- **zoxide** - Smart `cd` that learns your habits (`z project` jumps to most used match)
- **fzf** - Fuzzy finder for files and history (`Ctrl+R`)
- **50k history** - Large searchable command history

<p align="center">
  <a href="https://github.com/1uk4/dotfiles/issues">Report Bug</a>
  ·
  <a href="https://github.com/1uk4/dotfiles/issues">Request Feature</a>
</p>
