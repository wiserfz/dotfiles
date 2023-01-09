local status, ui = pcall(require, "dapui")

if not status then
  return
end

ui.setup({
  expand_lines = true,
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.5 },
        { id = "breakpoints", size = 0.15 },
        { id = "stacks", size = 0.2 },
        -- { id = "watches",     size = 0.15 }
      },
      size = 70,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.65 },
        { id = "console", size = 0.35 },
      },
      size = 20,
      position = "bottom",
    },
  },
})
