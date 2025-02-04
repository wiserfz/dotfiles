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

      -- save on format by goimports
      local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          require("go.format").goimports()
        end,
        group = format_sync_grp,
      })
    end,
    lsp_inlay_hints = {
      enable = false,
    },
  })
end

return M
