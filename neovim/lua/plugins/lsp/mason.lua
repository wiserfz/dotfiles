-- managing & installing lsp servers, linters & formatters
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig
  },
  config = function()
    -- import mason plugin safely
    local mason_status, mason = pcall(require, "mason")
    if not mason_status then
      return
    end

    -- import mason-lspconfig plugin safely
    local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
    if not mason_lspconfig_status then
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

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        -- "erlangls", -- erlang
        "gopls", -- golang
        "rust_analyzer", -- rust
        "lua_ls", -- lua
        "pyright", -- python
        "pylsp", -- python
        "bashls", -- bash
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })
  end,
}
