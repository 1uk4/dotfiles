function ColorMyPencils(color)
	color = color or "gruvbox"
	vim.cmd.colorscheme(color)

	-- Transparent BackgGround
	vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
	vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})

	-- Gitsigns - prominent gutter colors
	vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#b8bb26", bold = true })    -- green
	vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#fabd2f", bold = true }) -- yellow
	vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#fb4934", bold = true }) -- red
end

ColorMyPencils()
