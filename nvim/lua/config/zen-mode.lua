local zen_mode = require("zen-mode")
local wk = require("which-key")

local M = {}

function M.setup()
  ---@module "zen-mode"
  ---@type ZenOptions
  local opts = {
    window = {
      backdrop = 1,
      width = 150,
      height = 0.92,
    },
    plugins = {
      options = {
        enabled = false,
      },
      twilight = { enabled = false }, -- not install the folke/twilight.nvim plugin
      tmux = { enabled = true },
    },
    on_open = function(win)
      -- NOTE: Due to zen-mode plugin reset the fillchars option, so setup option here
      -- when trigger the zen mode, see: https://github.com/folke/zen-mode.nvim/issues/55
      vim.wo[win].fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:,foldinner: "
      if vim.g.neovide ~= nil then
        vim.g.neovide_opacity = 1.0
      end
    end,
    on_close = function()
      if vim.g.neovide ~= nil then
        vim.g.neovide_opacity = 0.8
      end
    end,
  }

  zen_mode.setup(opts)

  wk.add({
    { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
  })
end

return M
