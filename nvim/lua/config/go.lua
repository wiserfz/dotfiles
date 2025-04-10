local go = require("go")
local lsp = require("config.lspconfig")

local M = {}

function M.setup()
  go.setup({
    lsp_cfg = {
      capabilities = lsp.get_capabilities(),
    },
    lsp_on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)
    end,
    lsp_inlay_hints = {
      enable = false,
    },
    diagnostic = false,
  })
end

return M
