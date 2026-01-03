require("lukaflores.remap")
require("lukaflores.set")
require("lukaflores.packer")

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)

    if name:match("opencode") then
      vim.cmd("startinsert")
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end
  end,
})

