return {
  "akinsho/bufferline.nvim", -- file tabpage
  version = "v3.7.0",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local bufferline = require("bufferline")

    bufferline.setup({
      options = {
        separator_style = "thin",
        -- hover events
        hover = {
          enabled = true,
          delay = 100,
          reveal = { "close" },
        },
        -- underline indicator
        indicator = {
          style = "underline",
        },
        -- sidebar offset
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true, -- use a "true" to enable the default, or set your own character
          },
        },
        -- lsp indicators
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, level, _, _)
          local icon = level:match("error") and " " or " "
          return " " .. icon
        end,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    -- bufferline
    keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { noremap = true }) -- move to next tab buffer
    keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { noremap = true }) -- move to previous tab buffer
  end,
}
