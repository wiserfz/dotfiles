local indent_line = require("ibl")

local M = {}

function M.setup()
  ---@module "ibl"
  ---@type ibl.config
  local opts = {
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
  }

  indent_line.setup(opts)
end

return M
