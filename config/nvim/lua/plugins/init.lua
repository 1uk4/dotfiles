local g = vim.g
local fn = vim.fn
local utils = require("utils")
local nmap = utils.nmap
local env = vim.env
local cmd = vim.cmd
local plugLoad = fn["functions#PlugLoad"]
local plugBegin = fn["plug#begin"]
local plugEnd = fn["plug#end"]
local Plug = fn["plug#"]

plugLoad()
plugBegin("~/.config/nvim/plugged")

-- Theme
Plug 'ellisonleao/gruvbox.nvim'

-- NOTE: the argument passed to Plug has to be wrapped with single-quotes

-- a set of lua helpers that are used by other plugins
Plug "nvim-lua/plenary.nvim"

-- enables repeating other supported plugins with the . command
Plug "tpope/vim-repeat"

-- detect indent style (tabs vs. spaces)
Plug "tpope/vim-sleuth"

-- setup editorconfig
Plug "editorconfig/editorconfig-vim"

-- fugitive
Plug "tpope/vim-fugitive"
Plug "tpope/vim-rhubarb"
nmap("<leader>gr", ":Gread<cr>")
nmap("<leader>gb", ":G blame<cr>")



-- general plugins
-- Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx', 'html'] }
Plug "MaxMEllon/vim-jsx-pretty"
g.vim_jsx_pretty_highlight_close_tag = 1
Plug("leafgarland/typescript-vim", {["for"] = {"typescript", "typescript.tsx"}})

-- Todo Comments
Plug 'folke/todo-comments.nvim'

-- Open markdown files in Marked.app - mapped to <leader>m
-- Requires Node js and Yarn
Plug("iamcco/markdown-preview.nvim", {["do"] = "cd app && yarn install"})
nmap("<leader>m", ":MarkdownPreview<cr>") 
nmap("<leader>mq", ":MarkdownPreviewStop<cr>")

-- Latex Editor
Plug ("lervag/vimtex")
g.tex_flavor='latex'
g.vimtex_view_method="skim"
g.vimtex_quickfix_mode= 0 
g.vimtex_view_automatic = 0


-- Snippets
Plug "hrsh7th/cmp-vsnip"
Plug "hrsh7th/vim-vsnip"
Plug "hrsh7th/vim-vsnip-integ"
local snippet_dir = os.getenv("DOTFILES") .. "/config/nvim/snippets"
g.vsnip_snippet_dir = snippet_dir
g.vsnip_filetypes = {
  javascriptreact = {"javascript"},
  typescriptreact = {"typescript"},
  ["typescript.tsx"] = {"typescript"}
}

-- Snippets Jump Shortcut
vim.keymap.set(
  {"i", "s"},
  "<C-l>",
  [[vsnip#jumpable(1) ? "\<Plug>(vsnip-jump-next)" : "\<C-l>"]],
  { buffer = bufnr, expr = true, replace_keycodes = true, remap = true }
)

-- add color highlighting to hex values
Plug "norcalli/nvim-colorizer.lua"

-- use devicons for filetypes
Plug "kyazdani42/nvim-web-devicons"

-- fast lua file drawer
Plug "kyazdani42/nvim-tree.lua"

-- Show git information in the gutter
Plug "lewis6991/gitsigns.nvim"

-- Helpers to configure the built-in Neovim LSP client
Plug "neovim/nvim-lspconfig"

-- Helpers to install LSPs and maintain them
Plug "williamboman/nvim-lsp-installer"

--Auto Save
Plug "Pocco81/AutoSave.nvim"

-- neovim completion
Plug "hrsh7th/cmp-nvim-lsp"
Plug "hrsh7th/cmp-nvim-lua"
Plug "hrsh7th/cmp-buffer"
Plug "hrsh7th/cmp-path"
Plug "hrsh7th/nvim-cmp"

-- treesitter enables an AST-like understanding of files
Plug("nvim-treesitter/nvim-treesitter", {["do"] = ":TSUpdate"})
-- show treesitter nodes
Plug "nvim-treesitter/playground"
-- enable more advanced treesitter-aware text objects
Plug "nvim-treesitter/nvim-treesitter-textobjects"
-- add rainbow highlighting to parens and brackets
Plug "p00f/nvim-ts-rainbow"

-- show nerd font icons for LSP types in completion menu
Plug "onsails/lspkind-nvim"

-- base16 syntax themes that are neovim/treesitter-aware
Plug "RRethy/nvim-base16"

-- status line plugin
Plug "feline-nvim/feline.nvim"

-- automatically complete brackets/parens/quotes
Plug "windwp/nvim-autopairs"

-- Run prettier
Plug("prettier/vim-prettier", {["do"] = "yarn install --frozen-lockfile --production"})

-- Style the tabline without taking over how tabs and buffers work in Neovim
Plug "alvarosevilla95/luatab.nvim"

-- improve the default neovim interfaces, such as refactoring
Plug "stevearc/dressing.nvim"

-- Navigate a code base with a really slick UI
Plug "nvim-telescope/telescope.nvim"
Plug "nvim-telescope/telescope-rg.nvim"

-- Startup screen for Neovim
Plug "startup-nvim/startup.nvim"

-- enable copilot support for Neovim
Plug "github/copilot.vim"
-- if a copilot-aliased version of node exists from fnm, use that
local copilot_node_command = env.FNM_DIR .. "/aliases/copilot/bin/node"
if utils.file_exists(copilot_node_command) then
  -- vim.g.copilot_node_command = copilot_node_path
  -- for some reason, this works but the above line does not
  cmd('let g:copilot_node_command = "' .. copilot_node_command .. '"')
end

-- fzf
Plug "$HOMEBREW_PREFIX/opt/fzf"
Plug "junegunn/fzf.vim"

-- Power telescope with FZF
Plug("nvim-telescope/telescope-fzf-native.nvim", {["do"] = "make"})

-- Trouble LSP
Plug "folke/trouble.nvim"

-- Vim Wiki Note Taking
Plug "vimwiki/vimwiki"

plugEnd()

-- Once the plugins have been loaded, Lua-based plugins need to be required and started up
-- For plugins with their own configuration file, that file is loaded and is responsible for
-- starting them. Otherwise, the plugin itself is required and its `setup` method is called.
require("plugins.todo-comments")
require("plugins.gruvbox")
require("nvim-autopairs").setup()
require("colorizer").setup()
require("plugins.telescope")
require("plugins.gitsigns")
require("plugins.trouble")
require("plugins.fzf")
require("plugins.lspconfig")
require("plugins.completion")
require("plugins.treesitter")
require("plugins.nvimtree")
require("plugins.tabline")
require("plugins.feline")
require("plugins.startup")
