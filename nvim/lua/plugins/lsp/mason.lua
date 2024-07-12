-- managing & installing lsp servers, linters & formatters
-- install packages include:
-- rust_analyzer
-- buf
-- codelldb
-- codespell
-- dockerls
-- editorconfig-checker
-- erlangls
-- gopls goimports gofumpt gomodifytags gotests impl
-- hadolint
-- jsonls jq
-- alex markdown_oxide
-- pylsp ruff
-- bashls shellcheck shfmt
-- lua_ls stylua selene
-- yamlls yamlfmt yamllint

return {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  config = function()
    -- import mason plugin safely
    local mason_status, mason = pcall(require, "mason")
    if not mason_status then
      return
    end

    -- enable mason
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
  end,
}
