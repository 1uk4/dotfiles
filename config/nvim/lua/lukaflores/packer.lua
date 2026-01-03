-- This file can be loaded by calling `lua require('plugins')` from your init.vim
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope for file navigation
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                          , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Color Scheme
    use { "ellisonleao/gruvbox.nvim" }

    -- Treesitter : Highlighting
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use('nvim-treesitter/playground')

    -- Harpoon the Primeagen Plugin - File Navigation
    use('theprimeagen/harpoon')

    use('nvim-lua/plenary.nvim')

    -- Undo Tree -- Leader U
    use('mbbill/undotree')

    -- Vim Fugitive
    use('tpope/vim-fugitive')

    -- Gitsigns - show git changes in gutter
    use('lewis6991/gitsigns.nvim')

    -- Lualine - pretty statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Which-key - show keybindings popup
    use('folke/which-key.nvim')

    -- Better escape - jk to exit insert mode
    use('max397574/better-escape.nvim')

    -- Auto-pairs - auto close brackets
    use('windwp/nvim-autopairs')

    -- Comment.nvim - toggle comments with gcc
    use('numToStr/Comment.nvim')

    -- Trouble
    use {
      "folke/trouble.nvim",
      requires = "nvim-tree/nvim-web-devicons",
      config = function()
        require("trouble").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    }


    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x', -- Specify version 2.x
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    -- Latex
    use('lervag/vimtex')


   -- Zen Mode
    use("folke/zen-mode.nvim")

    -- Avante
    use {
        'yetone/avante.nvim',
        branch = 'main',
        run = 'make',
        requires = {
            { 'nvim-treesitter/nvim-treesitter' },
            { 'stevearc/dressing.nvim' },
            { 'MunifTanjim/nui.nvim' },
            { 'MeanderingProgrammer/render-markdown.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'nvim-tree/nvim-web-devicons' },
            { 'HakonHarnes/img-clip.nvim' },
        }
    }

    -- Claude Code
    use {
        'greggh/claude-code.nvim',
        requires = {
            'nvim-lua/plenary.nvim', -- Required for git operations
        },
        config = function()
            require('claude-code').setup()
        end
    }



    -- OpenCode Integration
    use {
      'NickvanDyke/opencode.nvim',
      requires = { 
        { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } }
      },
      config = function()
        -- Enable autoread for file reloading
        vim.o.autoread = true
        
        -- Set global configuration using the working format
        vim.g.opencode_opts = {
          provider = {
            enabled = "tmux",
            cmd = "opencode"
          }
        }
      end
    }


end)
