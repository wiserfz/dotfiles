local lsp = require("config.lspconfig")
local rust_config = require("rustaceanvim.config")
local wk = require("which-key")

-- debugging rust by codelldb
-- NOTE: install CodeLLDB via Mason, MasonInstall codelldb
local mason_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/"
local codelldb_path = mason_path .. "codelldb/extension/adapter/codelldb"
local liblldb_path = mason_path .. "codelldb/extension/lldb/lib/liblldb.dylib"

-- disable features for some projects
local disable_features_project = {
  "kafka-tower",
}

local M = {}

function M.setup()
  ---@return rustaceanvim.Opts
  vim.g.rustaceanvim = function()
    ---@type rustaceanvim.Opts
    local opts = {
      server = {
        capabilities = lsp.get_capabilities(),
        on_attach = function(client, bufnr)
          lsp.on_attach(client, bufnr)

          wk.add({
            noremap = true,
            silent = true,
            buffer = bufnr,

            {
              "<leader>ca",
              function()
                vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
              end,
              desc = "Rustaceanvim code action",
            },
            {
              "K",
              function()
                vim.cmd.RustLsp({ "hover", "actions" })
              end,
              desc = "Rustaceanvim hover actions",
            },
          })
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
            procMacro = {
              enable = true,
              attributes = {
                enable = true,
              },
            },
            files = {
              exclude = {
                ".git",
                ".gitlab-ci",
                ".idea",
                ".vscode",
                ".settings",
                "node_modules",
                "target",
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

    local cargo_options = {
      buildScripts = {
        enable = true,
      },
      features = "all",
    }

    local project_name = vim.fs.basename(vim.fn.getcwd())
    if vim.list_contains(disable_features_project, project_name) then
      cargo_options.features = nil
    end

    opts.server.default_settings["rust-analyzer"].cargo = cargo_options

    return opts
  end
end

return M
