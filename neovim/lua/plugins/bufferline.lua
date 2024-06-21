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
        diagnostics_indicator = function(_, _, diagnostics_dict, _)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " " or (e == "warning" and " " or " ")
            s = s .. n .. sym
          end
          return s
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
