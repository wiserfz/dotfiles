-- init.lua

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ","
vim.g.localleader = "\\"

-- Remove trailing spaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- IMPORTS
require("core.vars") -- Variables
require("core.opts") -- Options
require("core.keys") -- Keymaps
require("plugins-setup") -- Plugins

-- PLUGINS
require("plugins.color-scheme")
require("plugins.comment")
require("plugins.nvim-tree")
require("plugins.lualine")
require("plugins.telescope")
require("plugins.nvim-cmp")

-- LSP plugins
require("plugins.lsp.lspconfig")
require("plugins.lsp.mason")
require("plugins.lsp.lspsaga")
require("plugins.lsp.null-ls")
require("plugins.lsp.lsp-colors")

require("plugins.autopairs")
require("plugins.treesitter")
require("plugins.gitsigns")
require("plugins.todo-comment")
require("plugins.indent-line")
require("plugins.hlargs")
require("plugins.fidget")
require("plugins.trouble")
require("plugins.bufferline")
require("plugins.ufo")
require("plugins.dap-ui")
require("plugins.dap")
-- require("plugins.auto-save")
