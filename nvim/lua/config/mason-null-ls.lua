local mason_none_ls = require("mason-null-ls")

local M = {}

function M.setup()
  mason_none_ls.setup({
    ensure_installed = {
      "ruff",
      "buf",
      "codelldb",
      "codespell",
      "editorconfig-checker",
      "gofumpt",
      "goimports",
      "gomodifytags",
      "gotests",
      "hadolint",
      "impl",
      "jq",
      "markdown-oxide",
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
