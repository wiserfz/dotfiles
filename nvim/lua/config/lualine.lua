local lualine = require("lualine")
local diagnostics_icon = require("util").diagnostics
local lazy_status = require("lazy.status")
local devicons = require("nvim-web-devicons")

--@param name string @The name of the highlight group
--@return function @A function that returns the foreground color of the highlight group
local function fg(name)
  return function()
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
  end
end

local M = {}

function M.setup()
  local config = {
    options = {
      icons_enabled = true,
      component_separators = "",
      section_separators = { left = " ", right = "" },
      globalstatus = true,
      disabled_filetypes = {
        statusline = {
          "dashboard",
        },
      },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str)
            return " " .. str
          end,
          separator = { left = "", right = "" },
          color = { gui = "bold" },
          -- padding = { left = 1, right = 1 },
        },
      },
      lualine_b = { "branch" },
      lualine_c = {
        {
          "filename",
          path = 1,
          fmt = function(str)
            local name = str
            local extension = vim.fn.fnamemodify(name, ":e")
            local icon = devicons.get_icon(name, extension, { default = true })
            return icon .. " " .. str
          end,
        },
      },
      lualine_x = {
        {
          "diagnostics",
          symbols = {
            error = diagnostics_icon.ERROR,
            warn = diagnostics_icon.WARN,
            info = diagnostics_icon.INFO,
            hint = diagnostics_icon.HINT,
          },
        },
        {
          function()
            local style = vim.bo.expandtab and "Spaces" or "Tab Size"
            local size = vim.bo.expandtab and vim.bo.tabstop or vim.bo.shiftwidth
            return style .. ": " .. size
          end,
          cond = function()
            return vim.bo.filetype ~= ""
          end,
          color = fg("Number"),
        },
        {
          "encoding",
          fmt = function(str)
            return str:gsub("utf", "UTF")
          end,
          color = { fg = "#a9a1e1" },
        },
        {
          lazy_status.updates,
          cond = lazy_status.has_updates,
          color = fg("WarningMsg"),
        },
      },
      lualine_y = {
        { "fileformat", padding = { left = 2 } },
        { "progress", separator = " ", padding = { left = 1, right = 1 } },
      },
      lualine_z = {
        {
          "location",
          separator = { left = "", right = "" },
          -- padding = { left = 1, right = 1 },
        },
      },
    },
  }

  -- configure lualine with modified theme
  lualine.setup(config)
end

return M
