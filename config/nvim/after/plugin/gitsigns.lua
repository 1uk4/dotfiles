local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
  return
end

gitsigns.setup({
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '' },
    topdelete    = { text = '' },
    changedelete = { text = '┃' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Navigation between hunks
    map('n', ']c', gs.next_hunk, "Next change")
    map('n', '[c', gs.prev_hunk, "Prev change")

    -- Preview and revert
    map('n', '<leader>gp', gs.preview_hunk, "Preview hunk")
    map('n', '<leader>gr', gs.reset_hunk, "Reset hunk")
    map('n', '<leader>gR', gs.reset_buffer, "Reset buffer")

    -- Blame
    map('n', '<leader>gb', function() gs.blame_line({ full = true }) end, "Blame line")
  end
})
