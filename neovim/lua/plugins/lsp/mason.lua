-- managing & installing lsp servers, linters & formatters
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
