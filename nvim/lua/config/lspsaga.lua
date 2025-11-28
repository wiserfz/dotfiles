local saga = require("lspsaga")

local M = {}

function M.setup()
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
      ref_opt = false,
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
      win_width = 35,
      auto_preview = true,
      detail = false,
      keys = {
        jump = "<CR>",
      },
    },
  })
end

return M
