local ok, wk = pcall(require, 'which-key')
if not ok then
  return
end

wk.setup({
  delay = 300,
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
})

-- Register key groups for better organization
wk.add({
  { "<leader>g", group = "Git" },
  { "<leader>o", group = "OpenCode" },
  { "<leader>p", group = "Files" },
  { "<leader>v", group = "LSP" },
  { "<leader>z", group = "Zen" },
})
