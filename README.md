<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>


<!-- PROJECT LOGO -->

<div>
  <h2 align="center">Dotfiles</h2>
  
  <p align="center"> 
    My life inside the terminal
  </p>
    <br />
  <p align="center"> 
    <img src="/resources/images/workspace.png" alt="Logo" width="700" height="450">
    <br />
    <img src="/resources/images/lazygit.png" alt="logo" width="700" height="450">
    <br />
  </p>

  <p align="center">
    <br />
    <a href="https://github.com/lukaflores/dotfiles/issues">Report Bug</a>
    ·
    <a href="https://github.com/lukaflores/dotfiles/issues">Request Feature</a>
  </p>
</div>


<!-- ABOUT THE PROJECT -->
## About The Project

Dotfiles are highly personalized to the individual. I encourage anyone who is starting the process of creating dotfiles to find inspiration in the others whilst starting from scratch. 

Note: Before installing, please look through the code and understand. It will alter prexisting configurations.


<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

You need to have [XCode](https://developer.apple.com/downloads/index.action?=xcode) or, at the very minimum, the [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a much smaller download.

The easiest way to install the XCode Command Line Tools in OSX 10.9+ is to open up a terminal, type 
  ```sh
    xcode-select --install
  ``` 

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/lukaflores/dotfiles.git
   ```
2. Move Repository to `~/code` 
   ```sh
    mv dotfiles ~/code 
   ```
3. Use install script (Don't provide a parameter to see options) 
   ```sh
   ./install.sh all
   ```

4. Set up your local environment variables
   ```sh
   # Copy the template file to your home directory
   cp localenv.template ~/.localenv
   
   # Edit the file with your API keys and other sensitive information
   vim ~/.localenv
   ```
   

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- USAGE EXAMPLES -->
## Usage

### IDE Setup

Start a full IDE environment with Neovim + OpenCode side by side:
```sh
ide [file] [--vertical] [--size=30]
```

### Tmux

Start a tmux session: `tm`

**Prefix:** `Ctrl+a`

| Key | Action |
|-----|--------|
| `prefix + Tab` | Toggle between panes |
| `prefix + z` | Zoom pane fullscreen |
| `prefix + g` | Open Lazygit |
| `prefix + i` | Open Calcurse |
| `prefix + h/j/k/l` | Move between panes |
| `prefix + H/J/K/L` | Resize panes |
| `prefix + \|` | Split horizontal |
| `prefix + -` | Split vertical |
| `prefix + r` | Reload config |

### Neovim

**Leader:** `Space`

Install plugins with `:PackerSync`

#### File Navigation
| Key | Action |
|-----|--------|
| `<leader>pv` | Open file explorer |
| `<leader>pf` | Find files (Telescope) |
| `<C-p>` | Git files |
| `<leader>ps` | Grep search |
| `<C-e>` | Harpoon menu |
| `<C-h/t/n/s>` | Harpoon files 1-4 |
| `<leader>a` | Add file to Harpoon |

#### Editing
| Key | Action |
|-----|--------|
| `<leader>y` / `<leader>Y` | Yank to system clipboard |
| `<leader>d` | Delete to void register |
| `<leader>p` | Paste without losing clipboard |
| `<leader>s` | Search/replace word under cursor |
| `<leader>f` | Format file |

#### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover info |
| `<leader>vd` | Diagnostics float |
| `<leader>vca` | Code action |
| `<leader>vrr` | References |
| `<leader>vrn` | Rename |

#### Git (Fugitive + Gitsigns + Telescope)
| Key | Action |
|-----|--------|
| `<leader>gs` | Git status (Fugitive) |
| `<leader>gd` | Diff current file vs HEAD |
| `<leader>gt` | Git status - changed files (Telescope) |
| `<leader>gc` | Git commits (Telescope) |
| `<leader>gB` | Git branches (Telescope) |
| `]c` / `[c` | Next/prev change |
| `<leader>gp` | Preview hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gR` | Reset buffer |
| `<leader>gb` | Blame line |

#### OpenCode Integration
| Key | Action |
|-----|--------|
| `<leader>oo` | Toggle OpenCode |
| `<leader>oa` | Toggle Neovim / OpenCode pane |
| `<leader>of` | Ask about file |
| `<leader>on` | New session |
| `<leader>oe` | Explain cursor |
| `<leader>or` | Review file |
| `<leader>od` | Document selection (visual) |

#### Code Review Workflow
1. `<leader>gt` - See all changed files
2. Select file to open
3. `]c` / `[c` - Jump between changes
4. `<leader>gp` - Preview hunk inline
5. `<leader>gd` - Full side-by-side diff
6. `<C-a> z` - Zoom fullscreen to read
7. `<leader>gr` - Reset unwanted changes

#### Other
| Key | Action |
|-----|--------|
| `<leader>u` | Undotree |
| `<leader>zz` | Zen mode |
| `<leader>xq` | Trouble quickfix |
| `<C-d>` / `<C-u>` | Half-page jump (centered) |

### LaTeX

| Key | Action |
|-----|--------|
| `\ll` | Compile |
| `\lv` | Open PDF viewer |
| `\le` | Error buffer |
| `<C-f>` | Create Inkscape figure |
| `<C-l>` | Edit Inkscape figures |

<p align="right">(<a href="#readme-top">back to top</a>)</p>




<!-- CONTACT -->
## Contact

Luka Flores - [@LukaFlores12](https://twitter.com/LukaFlores12)


<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* Inspiration [Niki Nisi Dotfiles](https://github.com/nicknisi/dotfiles)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

