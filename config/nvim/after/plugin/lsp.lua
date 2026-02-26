---
-- Capabilities: merge cmp_nvim_lsp into lspconfig defaults
-- Must run before any server setup
---
vim.opt.signcolumn = 'yes'

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

---
-- Keymaps on LSP attach
---
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf, remap = false }
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if client and client.name == 'eslint' then
      vim.cmd.LspStop('eslint')
      return
    end

    vim.keymap.set('n', 'gd',           vim.lsp.buf.definition,       opts)
    vim.keymap.set('n', 'K',            vim.lsp.buf.hover,             opts)
    vim.keymap.set('n', '<leader>vws',  vim.lsp.buf.workspace_symbol,  opts)
    vim.keymap.set('n', '<leader>vd',   vim.diagnostic.open_float,     opts)
    vim.keymap.set('n', '[d',           vim.diagnostic.goto_next,      opts)
    vim.keymap.set('n', ']d',           vim.diagnostic.goto_prev,      opts)
    vim.keymap.set('n', '<leader>vca',  vim.lsp.buf.code_action,       opts)
    vim.keymap.set('n', '<leader>vrr',  vim.lsp.buf.references,        opts)
    vim.keymap.set('n', '<leader>vrn',  vim.lsp.buf.rename,            opts)
    vim.keymap.set('i', '<C-h>',        vim.lsp.buf.signature_help,    opts)
  end,
})

---
-- Mason + mason-lspconfig
---
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'rust_analyzer',
  },
  handlers = {
    -- Default handler for all servers
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,

    -- lua_ls: suppress false vim global warnings
    lua_ls = function()
      require('lspconfig').lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })
    end,
  },
})

---
-- Diagnostic display
---
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN]  = 'W',
      [vim.diagnostic.severity.HINT]  = 'H',
      [vim.diagnostic.severity.INFO]  = 'I',
    },
  },
})

---
-- Snippet engine
---
local luasnip = require('luasnip')

luasnip.config.set_config({
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave',
})

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_snipmate').lazy_load({ paths = '~/dotfiles/config/nvim/snippets' })

---
-- nvim-cmp
---
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp',  keyword_length = 3 },
    { name = 'buffer',    keyword_length = 3 },
    { name = 'luasnip',   keyword_length = 1 },
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>']     = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>']     = cmp.mapping.select_next_item(cmp_select),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),

    -- jump to next snippet placeholder
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    -- jump to previous snippet placeholder
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
})
