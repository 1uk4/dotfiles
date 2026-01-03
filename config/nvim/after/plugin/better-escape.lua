local ok, escape = pcall(require, 'better_escape')
if not ok then
  return
end

escape.setup({
  timeout = 200,
  default_mappings = false,
  mappings = {
    i = {
      j = {
        k = "<Esc>",
        j = "<Esc>",
      },
    },
  },
})
