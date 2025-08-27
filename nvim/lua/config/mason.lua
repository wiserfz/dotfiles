local mason = require("mason")
local mason_tool_installer = require("mason-tool-installer")

local M = {}

function M.setup()
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  mason_tool_installer.setup({
    ensure_installed = {
      "ruff",
      "codelldb",
      "editorconfig-checker",
      "gofumpt",
      "goimports",
      "gomodifytags",
      "gotests",
      -- WARN: hadolint only release binary for mac with intel CPU
      -- "hadolint",
      "impl",
      "jq",
      -- WARN: mac with intel CPU which only can install selene@0.26.1
      -- See issue: https://github.com/williamboman/mason.nvim/issues/1693
      "selene",
      "shellcheck",
      "shfmt",
      "sqlfmt",
      "sqlfluff",
      "stylua",
      "yamlfmt",
      "yamllint",
    },
    auto_update = false,
    run_on_start = true,
    start_delay = 3000, -- 3 second delay
    integrations = {
      ["mason-lspconfig"] = false,
      ["mason-null-ls"] = false,
      ["mason-nvim-dap"] = true,
    },
  })
end

return M
