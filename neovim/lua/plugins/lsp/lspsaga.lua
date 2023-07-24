-- import lspsaga safely
local status, saga = pcall(require, "lspsaga")
if not status then
  return
end

saga.setup({
  -- keybinds for navigation in lspsaga window
  scroll_preview = { scroll_up = "<C-k>", scroll_down = "<C-j>" },
  -- when there has code action it will show a lightbulb
  lightbulb = {
    sign = false,
  },
  beacon = {
    enable = false,
  },
  finder = {
    keys = {
      toggle_or_open = "<CR>",
      quit = "q",
      close = "<ESC>",
    },
  },
  rename = {
    in_select = false,
  },
  -- ui = {
  --   kind = {
  --     Function = { " ", "Function" },
  --   },
  -- },
})
