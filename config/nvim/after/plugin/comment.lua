local ok, comment = pcall(require, 'Comment')
if not ok then
  return
end

comment.setup({
  -- gcc to comment line
  -- gbc to block comment
  -- gc in visual mode to comment selection
})
