-- init.lua

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ","
vim.g.localleader = "\\"

-- IMPORTS
require("core.vars") -- Variables
require("core.opts") -- Options
require("core.keys") -- Keymaps
require("core.color-scheme") -- Color-scheme
require("plugins-setup") -- Plugins

-- PLUGINS
require("plugins.comment")
require("plugins.nvim-tree")
require("plugins.lualine")
require("plugins.telescope")
require("plugins.nvim-cmp")

-- LSP plugins
require("plugins.lsp.mason")
require("plugins.lsp.lspsaga")
require("plugins.lsp.lspconfig")
require("plugins.lsp.null-ls")

require("plugins.autopairs")
require("plugins.treesitter")
require("plugins.gitsigns")
