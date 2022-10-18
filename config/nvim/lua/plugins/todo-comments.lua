require("todo-comments").setup{
  keywords = {
    TODO = {
      icon= " ",
      color = "info",
    },
    PHYS23 = {
      icon= " ",
      color = "#2563EB",
    },
    MTH8 = {
      icon= " ",
      color = "#FEF3D2",
    },
    CS17 = {
      icon= " ",
      color = "#D5D000",
    },
    COM11 = {
      icon= " ",
      color = "#D87D0D",
    },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    FIX = {icon = " ",color = "warning",alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
  }
}
