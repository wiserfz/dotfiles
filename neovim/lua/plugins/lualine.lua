-- plugin of lualine

local status, lualine = pcall(require, "lualine")
if not status then
  return
end

-- get lualine theme
-- local lualine_theme = require("lualine.themes.onedark")

local colors = {
  black = "#282828",
  white = "#ebdbb2",
  red = "#fb4934",
  green = "#b8bb26",
  blue = "#83a598",
  yellow = "#fe8019",
  gray = "#a89984",
  darkgray = "#3c3836",
  lightgray = "#504945",
  inactivegray = "#7c6f64",
  darkblue = "#112233",
  lightgreen = "#83AA81",
}

local indent = {
  function()
    -- local fn = vim.fn
    -- local numTabs = fn.len(fn.filter(fn.getbufline(fn.bufname("%"), 1, 250), 'v:val =~ "^\\t"'))
    -- local numSpaces = fn.len(fn.filter(fn.getbufline(fn.bufname("%"), 1, 250), 'v:val =~ "^ "'))
    --
    -- if numTabs > numSpaces then
    --   vim.opt_local.expandtab = false
    -- end

    local style = vim.bo.expandtab and "Spaces" or "Tab Size"
    local size = vim.bo.expandtab and vim.bo.tabstop or vim.bo.shiftwidth
    return style .. ": " .. size
  end,
  cond = function()
    return vim.bo.filetype ~= ""
  end,
}

local custom_gruvbox = require("lualine.themes.gruvbox")

-- Change the background of lualine_c section for normal mode
custom_gruvbox.normal.c.bg = colors.darkblue
custom_gruvbox.insert.c.bg = colors.darkblue
custom_gruvbox.insert.c.fg = colors.lightgreen
custom_gruvbox.visual.c.fg = colors.yellow
custom_gruvbox.visual.c.bg = colors.darkblue
custom_gruvbox.command.c.fg = colors.green
custom_gruvbox.command.c.bg = colors.darkblue
-- custom_gruvbox.visual.c.gui = "bold" 加粗
custom_gruvbox.replace.c.fg = colors.red

-- configure lualine with modified theme
lualine.setup({
  options = {
    theme = custom_gruvbox,
    -- fmt = string.lower,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "packer", "NvimTree" }, -- disable status line
  },
  sections = {
    lualine_c = {
      {
        "filename",
        path = 3, -- 0: Just the filename; 3: Absolute path, with tilde as the home directory
      },
    },
    lualine_x = { indent, "encoding", "fileformat", "filetype" },
  },
})
