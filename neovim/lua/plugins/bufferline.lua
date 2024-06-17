return {
  "akinsho/bufferline.nvim", -- file tabpage
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  version = "4.*",
  config = function()
    local bufferline = require("bufferline")

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
        diagnostics_indicator = function(_, level, _, _)
          local icon = level:match("error") and " " or " "
          return " " .. icon
        end,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness
    local options = { noremap = true, silent = true }
    -- bufferline
    keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", options) -- move to next tab buffer
    keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", options) -- move to previous tab buffer
  end,
}
