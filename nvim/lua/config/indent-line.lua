local indent_line = require("ibl")

local M = {}

function M.setup()
  indent_line.setup({
    indent = {
      char = "┊",
      priority = 2,
    },
    scope = {
      enabled = false,
    },
    exclude = {
      filetypes = {
        "lspinfo",
        "lazy",
        "checkhealth",
        "help",
        "man",
        "TelescopePrompt",
        "TelescopeResults",
        "dashboard",
      },
    },
  })
end

return M
