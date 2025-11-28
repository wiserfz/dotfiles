local fidget = require("fidget")

local M = {}

function M.setup()
  local opt = {
    progress = {
      display = {
        done_icon = "✔ ",
        progress_style = "Comment",
        group_style = "Title",
        icon_style = "Title",
      },
      ignore = {
        "null-ls",
        "copilot",
        "harper_ls",
      },
    },
    notification = {
      window = {
        normal_hl = "Comment",
        winblend = 0,
      },
    },
  }
  -- WARN: temporary fix for fidget transparency issue in neovide
  if vim.g.neovide ~= nil then
    opt.notification.window.winblend = 100
  end

  fidget.setup(opt)
end

return M
