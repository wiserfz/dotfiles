-- color scheme

local status, scheme = pcall(require, "kanagawa")
if not status then
  print("Colorscheme of kanagawa not found!")
  return
end

-- for onedark color scheme
-- scheme.setup({
--   style = "darker",
--   term_colors = true, -- Change terminal color as per the selected theme style
--   lualine = {
--     transparent = true, -- lualine center bar transparency
--   },
-- })

-- scheme.load()

scheme.setup({
  keywordStyle = { italic = false, bold = true },
})
vim.cmd("colorscheme kanagawa")

-- Highlight colors
vim.cmd([[
  hi CursorLineNr guifg=#7e9cd8
  hi FoldColumn guifg=#29292c guibg=#26292c
  hi GitSignsAdd guibg=#193549 guifg=#3ad900
  hi GitSignsChange guibg=#193549 guifg=#ffc600
  hi GitSignsDelete guibg=#193549 guifg=#ff2600
  hi ColorColumn guifg=NONE guibg=#204563 gui=NONE
]])
