return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
  config = function()
    local setup, saga = pcall(require, "lspsaga")
    if not setup then
      return
    end

    saga.setup({
      -- when there has code action it will show a lightbulb
      lightbulb = {
        enable = false,
        sign = false,
      },
      beacon = {
        enable = false,
      },
      finder = {
        keys = {
          toggle_or_open = "<CR>",
        },
      },
      rename = {
        in_select = false,
        keys = {
          quit = "<ESC>",
        },
      },
      outline = {
        keys = {
          jump = "<CR>",
        },
      },
    })
  end,
}
