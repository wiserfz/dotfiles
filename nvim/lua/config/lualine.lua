local lualine = require("lualine")
local diagnostics_icon = require("util").diagnostics
local lazy_status = require("lazy.status")

--@param name string @The name of the highlight group
--@return function @A function that returns the foreground color of the highlight group
local function fg(name)
  return function()
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
  end
end

--@return table @A lualine component that displays the status of Code Companion requests
local function code_companion_status()
  local code_companion = require("lualine.component"):extend()
  code_companion.processing = false
  code_companion.spinner_index = 1

  local spinner_symbols = {
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏",
  }
  local spinner_symbols_len = 10

  -- Initializer
  function code_companion:init(options)
    code_companion.super.init(self, options)

    local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionRequest*",
      group = group,
      callback = function(request)
        if request.match == "CodeCompanionRequestStarted" then
          self.processing = true
        elseif request.match == "CodeCompanionRequestFinished" then
          self.processing = false
        end
      end,
    })
  end

  -- Function that runs every time statusline is updated
  function code_companion:update_status()
    if self.processing then
      self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
      return spinner_symbols[self.spinner_index]
    else
      return nil
    end
  end

  return code_companion
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
          separator = { left = "", right = "" },
          -- padding = { left = 1, right = 1 },
        },
      },
      lualine_b = { "branch" },
      lualine_c = {
        {
          "filename",
          path = 1,
        },
        {
          "diagnostics",
          symbols = {
            error = diagnostics_icon.Error,
            warn = diagnostics_icon.Warn,
            info = diagnostics_icon.Info,
            hint = diagnostics_icon.Hint,
          },
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
          color = fg("String"),
        },
        {
          "encoding",
          fmt = function(str)
            return str:gsub("utf", "UTF")
          end,
          color = { fg = "#a9a1e1" },
        },
        { "filetype", color = { fg = "#ECBE7B" } },
        { code_companion_status },
        {
          lazy_status.updates,
          cond = lazy_status.has_updates,
          color = fg("Special"),
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
