local mason_none_ls = require("mason-null-ls")

local M = {}

function M.setup()
  mason_none_ls.setup({
    ensure_installed = {
      "ruff",
      "buf",
      "codelldb",
      "editorconfig-checker",
      "gofumpt",
      "goimports",
      "gomodifytags",
      "gotests",
      "hadolint",
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
    automatic_installation = true,
  })
end

return M
