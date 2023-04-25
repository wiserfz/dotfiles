-- plugin of lualine

local status, lualine = pcall(require, "lualine")
if not status then
  return
end

-- get lualine theme
-- local lualine_theme = require("lualine.themes.onedark")

-- new colors for theme
-- local new_colors = {
-- 	blue = "#65D1FF",
-- 	green = "#3EFFDC",
-- 	violet = "#FF61EF",
-- 	yellow = "#FFDA7B",
-- 	black = "#000000",
-- }

-- change tokyonight theme colors
-- lualine_theme.normal.a.bg = new_colors.blue
-- lualine_theme.insert.a.bg = new_colors.green
-- lualine_theme.visual.a.bg = new_colors.violet
-- lualine_theme.command = {
-- 	a = {
-- 		gui = "bold",
-- 		bg = new_colors.yellow,
-- 		fg = new_colors.black,
-- 	},
-- }

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

-- configure lualine with modified theme
lualine.setup({
  options = {
    theme = "kanagawa",
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
