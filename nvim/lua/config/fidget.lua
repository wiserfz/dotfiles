local fidget = require("fidget")

local fidget_winblend = function()
  if vim.g.neovide_multigrid then
    return 80
  end
  return vim.o.winblend
end

local M = {}

function M.setup()
  local winblend = fidget_winblend()

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
        winblend = winblend,
      },
    },
  }

  fidget.setup(opt)
end

return M
