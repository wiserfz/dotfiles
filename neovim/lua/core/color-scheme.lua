-- color scheme

local status, _ = pcall(vim.cmd, "colorscheme tokyonight")
if not status then
  print("Colorscheme of tokyonight not found!")
  return
end
