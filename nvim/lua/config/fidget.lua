local fidget = require("fidget")

local M = {}

function M.setup()
  fidget.setup({
    progress = {
      display = {
        done_icon = "✔ ",
        done_ttl = 2,
      },
      ignore = {
        "null-ls",
        "copilot",
        "harper_ls",
      },
    },
  })
end

return M
