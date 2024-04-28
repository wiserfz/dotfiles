return {
  "nvimdev/lspsaga.nvim",
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
          quit = "q",
          close = "<ESC>",
        },
      },
      rename = {
        in_select = false,
      },
      definition = {
        keys = {
          tabnew = "<C-c>n",
        },
      },
    })
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- optional
    "nvim-tree/nvim-web-devicons", -- optional
  },
}
