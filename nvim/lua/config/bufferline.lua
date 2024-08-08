local bufferline = require("bufferline")
local wk = require("which-key")

local M = {}
local theme = require("kanagawa.colors").setup().theme

function M.setup()
  bufferline.setup({
    options = {
      separator_style = "thin",
      -- underline indicator
      -- indicator = {
      --   style = "underline",
      -- },
      -- sidebar offset
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          separator = true, -- use a "true" to enable the default, or set your own character
        },
      },
      -- lsp indicators
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diagnostics_dict, _)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " " or (e == "warning" and " " or " ")
          s = s .. n .. sym
        end
        return s
      end,
    },
    highlights = {
      fill = {
        bg = theme.ui.bg,
      },
      buffer_selected = {
        bg = theme.ui.bg_p1,
      },
      offset_separator = {
        bg = theme.ui.bg,
      },
      close_button_selected = {
        bg = theme.ui.bg_p1,
      },
      modified_selected = {
        bg = theme.ui.bg_p1,
      },
      hint_selected = {
        bg = theme.ui.bg_p1,
      },
      hint_diagnostic_selected = {
        bg = theme.ui.bg_p1,
      },
      info_selected = {
        bg = theme.ui.bg_p1,
      },
      info_diagnostic_selected = {
        bg = theme.ui.bg_p1,
      },
      warning_selected = {
        bg = theme.ui.bg_p1,
      },
      warning_diagnostic_selected = {
        bg = theme.ui.bg_p1,
      },
      error_selected = {
        bg = theme.ui.bg_p1,
      },
      error_diagnostic_selected = {
        bg = theme.ui.bg_p1,
      },
      duplicate_selected = {
        bg = theme.ui.bg_p1,
      },
    },
  })

  -- bufferline
  wk.add({
    noremap = false,
    silent = true,

    { "<leader>b", group = "buffer" },

    { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { "<leader>bd", "<cmd>bd<cr>", desc = "Close buffer" },
  })
end

return M
