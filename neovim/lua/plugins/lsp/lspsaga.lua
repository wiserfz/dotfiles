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
    enable = false,
  },
  ui = {
    colors = {
      --float window normal bakcground color
      normal_bg = "#1c1c19",
      --title background color
      title_bg = "#afd700",
    },
  },
})
