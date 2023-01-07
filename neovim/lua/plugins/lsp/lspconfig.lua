-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
  return
end

local map = vim.keymap

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  map.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  map.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
  map.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  map.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  map.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  map.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  map.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  map.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  map.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  map.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  map.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  map.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

  -- typescript specific keymaps (e.g. rename file and update imports)
  if client.name == "tsserver" then
    map.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
    map.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
    map.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
  end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure rust_analyzer server
lspconfig["rust_analyzer"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
	["rust-analyzer"] = {
	  inlayHints = {
		closingBraceHints = {
		  enable = false,
		},
		chainingHints = {
		  enable = false,
		},
		parameterHints = {
		  enable = false,
		},
		typeHints = {
		  enable = true,
		},
	  },
	  server = {
		extraEnv = {
		  CHALK_OVERFLOW_DEPTH = "500",
		  CHALK_SOLVER_MAX_SIZE = "100",
		},
	  },
	}
  }
})

-- configure typescript server with plugin
typescript.setup({
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  },
})

-- configure gopls server
lspconfig["gopls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure erlangls server
lspconfig["erlangls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure lua server (with special settings)
lspconfig["sumneko_lua"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = { -- custom settings for lua
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})
