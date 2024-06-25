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

end)
