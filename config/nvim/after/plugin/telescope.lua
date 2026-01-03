local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({search = vim.fn.input("Grep > ")});
end)

-- Git integration
vim.keymap.set('n', '<leader>gt', builtin.git_status, { desc = "Git status (changed files)" })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = "Git commits" })
vim.keymap.set('n', '<leader>gB', builtin.git_branches, { desc = "Git branches" })
