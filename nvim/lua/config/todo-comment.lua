local todo = require("todo-comments")
local util = require("util")

local M = {}

function M.setup()
  todo.setup({
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#de5d68" },
      warning = { "DiagnosticWarning", "WarningMsg", "#eeb927" },
      info = { "DiagnosticInfo", "#57a5e5" },
      hint = { "DiagnosticHint", "#bb70d2" },
      default = { "Identifier", "#7C3AED" },
      test = { "Identifier", "#b930e7" },
    },
  })

  util.map("n", "<leader>]t", function()
    todo.jump_next()
  end, { desc = "Next todo comment" })

  util.map("n", "<leader>[t", function()
    todo.jump_prev()
  end, { desc = "Previous todo comment" })
end

return M
