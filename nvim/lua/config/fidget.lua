local fidget = require("fidget")
-- local notification = require("fidget.notification")

local M = {}

function M.setup()
  -- local notification_configs = vim.tbl_extend("force", notification.default_config, {
  --   warn_style = "Comment",
  -- })

  fidget.setup({
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
      },
    },
  })
end

return M
