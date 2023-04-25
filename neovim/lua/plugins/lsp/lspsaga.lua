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
    enable_in_insert = true,
    sign = false,
  },
  beacon = {
    enable = false,
  },
  finder = {
    keys = {
      edit = "<CR>",
    },
  },
  rename = {
    in_select = false,
  },
})
