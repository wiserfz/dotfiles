local util = require("util")
local lsp = require("config.lspconfig")
local rust_config = require("rustaceanvim.config")

-- debugging rust by codelldb
-- NOTE: install CodeLLDB via Mason, MasonInstall codelldb
local mason_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/"
local codelldb_path = mason_path .. "codelldb/extension/adapter/codelldb"
local liblldb_path = mason_path .. "codelldb/extension/lldb/lib/liblldb.dylib"

local M = {}

function M.setup()
  vim.g.rustaceanvim = {
    tools = {
      inlay_hints = {
        show_parameter_hints = false,
        only_current_line = true,
      },
    },
    server = {
      capabilities = lsp.get_capabilities(),
      on_attach = function(client, bufnr)
        lsp.on_attach(client, bufnr)
        -- keybind options
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Code action groups
        util.map("n", "<leader>ca", function()
          vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
        end, opts)

        -- Hover actions
        util.map("n", "K", function()
          vim.cmd.RustLsp({ "hover", "actions" })
        end, opts)
      end,
      default_settings = {
        ["rust-analyzer"] = {
          imports = {
            granularity = {
              group = "module",
            },
            prefix = "self",
          },
          checkOnSave = true,
          check = {
            command = "clippy",
          },
          cargo = {
            buildScripts = {
              enable = true,
            },
          },
          procMacro = {
            enable = true,
            attributes = {
              enable = true,
            },
          },
        },
      },
    },
    -- for debugger
    dap = {
      adapter = rust_config.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  }
end

return M
