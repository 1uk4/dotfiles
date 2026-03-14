---@diagnostic disable: undefined-global
-- IDE watcher: auto-reload buffers from disk on a timer.
-- Used by the `ide` script so nvim picks up file changes
-- made in another tmux pane (e.g. opencode).
-- Diffview refresh is handled by the ide script via tmux send-keys.

vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

vim.fn.timer_start(2000, function()
  vim.schedule(function()
    vim.cmd("silent! checktime")
  end)
end, { ["repeat"] = -1 })
