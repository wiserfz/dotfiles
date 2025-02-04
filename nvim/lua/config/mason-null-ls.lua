local mason_none_ls = require("mason-null-ls")

local M = {}

function M.setup()
  mason_none_ls.setup({
    ensure_installed = {},
    automatic_installation = true,
  })
end

return M
