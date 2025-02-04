local lualine = require("lualine")

--@return string @The status of the LSP client
local function lsp_status()
  return require("lsp-status").status()
end

local M = {}

function M.setup()
  local lualine_kanagawa = require("lualine.themes.kanagawa")
  lualine_kanagawa.normal.b.bg = "#3B4261"
  lualine_kanagawa.normal.c.bg = "#1F2335"

  local config = {
    options = {
      icons_enabled = true,
      theme = lualine_kanagawa,
      component_separators = "",
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {
          "dashboard",
          -- "NvimTree",
        },
      },
    },
    sections = {
      lualine_c = {
        {
          "filename",
          -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory
          path = 1,
        },
      },
      lualine_x = {
        {
          function()
            local style = vim.bo.expandtab and "Spaces" or "Tab Size"
            local size = vim.bo.expandtab and vim.bo.tabstop or vim.bo.shiftwidth
            return style .. ": " .. size
          end,
          cond = function()
            return vim.bo.filetype ~= ""
          end,
          color = { fg = "#6EB0A3" },
        },
        {
          "encoding",
          fmt = function(str)
            return str:gsub("utf", "UTF")
          end,
          color = { fg = "#a9a1e1" },
        },
        "fileformat",
        { "filetype", color = { fg = "#ECBE7B" } },
        { lsp_status, color = { fg = "#a9b665" } },
      },
    },
  }

  -- configure lualine with modified theme
  lualine.setup(config)
end

return M
