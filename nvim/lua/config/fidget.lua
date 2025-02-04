local fidget = require("fidget")

local M = {}

function M.setup()
  fidget.setup({
    progress = {
      display = {
        done_icon = "",
        done_ttl = 2,
      },
      ignore = { "null-ls" },
    },
    notification = {
      window = {
        max_height = 4,
        normal_hl = "FidgetNormal",
      },
    },
  })
end

return M
