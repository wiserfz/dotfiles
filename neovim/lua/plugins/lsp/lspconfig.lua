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

local map = vim.keymap.set

-- enable keybinds only for when lsp server available
local function on_attach(client, bufnr)
  -- disable formatting for LSP clients as this is handled by null-ls
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  map("n", "gf", "<cmd>Lspsaga finder def+ref<CR>", opts) -- show definition, references
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  -- map("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
  map("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  map("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  map("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side
  map({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>") -- float terminal option-d
end

-- disable lsp log
vim.lsp.set_log_level("off")

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local servers = {
  "bashls",
  "lua_ls",
  "erlangls",
  "pyright",
  -- "pylsp",
  "rust_analyzer",
  "gopls",
}

for _, server in pairs(servers) do
  if server == "rust_analyzer" then
    -- debugging rust by codelldb
    -- NOTE: Must install CodeLLDB
    -- See https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
    local extension_path = vim.env.HOME .. "/.local/codelldb/extension"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

    -- configure rust_analyzer server
    local rt_status, rt = pcall(require, "rust-tools")
    if rt_status then
      rt.setup({
        server = {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)

            map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { buffer = bufnr }) -- goto definition by lspsaga
            map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { buffer = bufnr }) -- see definition and make edits in window
            -- Hover actions
            map("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            map("n", "<Leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
          standalone = true,
          settings = {
            ["rust-analyzer"] = {
              assist = {
                importGranularity = "module",
                importPrefix = "by_self",
              },
              cargo = {
                loadOutDirsFromCheck = true,
                -- features = "all",
              },
              checkOnSave = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
        tools = {
          inlay_hints = {
            show_parameter_hints = false,
            only_current_line = true,
          },
        },
        -- for debugger
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      })
    end
  -- elseif server == "gopls" then
  --   -- configure golang server
  --   local go_status, go = pcall(require, "go")
  --   if go_status then
  --     go.setup({
  --       --[[
  --           true: use non-default gopls setup specified in go/lsp.lua
  --           false: do nothing
  --           if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
  --           lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
  --       --]]
  --       lsp_cfg = {
  --         capabilities = capabilities,
  --       },
  --       --[[
  --           nil: use on_attach function defined in go/lsp.lua,
  --           when lsp_cfg is true
  --           if lsp_on_attach is a function: use this function as on_attach function for gopls
  --       --]]
  --       lsp_on_attach = function(client, bufnr)
  --         on_attach(client, bufnr)
  --
  --         map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
  --         map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
  --       end,
  --       lsp_diag_update_in_insert = true,
  --       dap_debug_gui = true, -- bool|table put your dap-ui setup here, set to false to disable
  --       dap_port = -1, -- can be set to a number, if set to -1 go.nvim will pickup a random port
  --       trouble = true,
  --       -- luasnip = true,
  --     })
  --   end
  elseif server == "lua_ls" then
    -- configure lua server (with special settings)
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
      end,
      settings = { -- custom settings for lua
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
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
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    })
  elseif server == "pylsp" then
    lspconfig["pylsp"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
      end,
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = { enabled = false },
            pyflakes = { enabled = false },
          },
        },
      },
    })
  else
    lspconfig[server].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
      end,
    })
  end
end
