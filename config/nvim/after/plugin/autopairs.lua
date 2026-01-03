local ok, autopairs = pcall(require, 'nvim-autopairs')
if not ok then
  return
end

autopairs.setup({
  check_ts = true,
  disable_filetype = { "TelescopePrompt", "vim" },
})

-- Integration with nvim-cmp
local cmp_ok, cmp = pcall(require, 'cmp')
if cmp_ok then
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end
