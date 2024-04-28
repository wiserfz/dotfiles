return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")

    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    local keymap = vim.keymap
    -- enable keybinds only for when lsp server available
    local function on_attach(client, bufnr)
      -- disable formatting for LSP clients as this is handled by null-ls
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      -- keybind options
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- set keybinds
      keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts) -- goto definition by lspsaga
      keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
      keymap.set("n", "gf", "<cmd>Lspsaga finder def+ref<CR>", opts) -- show definition, references
      keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
      keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
      keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
      -- keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
      keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
      keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
      keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
      keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
      keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side
      keymap.set({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>") -- float terminal option-d
    end

    -- disable lsp log
    vim.lsp.set_log_level("off")

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
    }

    for _, server in pairs(servers) do
      if server == "rust_analyzer" then
        -- debugging rust by codelldb
        -- NOTE: Must install CodeLLDB
        -- See https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(via--codelldb)
        local extension_path = vim.env.HOME .. "/.local/codelldb/extension"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

        vim.g.rustaceanvim = {
          tools = {
            inlay_hints = {
              show_parameter_hints = false,
              only_current_line = true,
            },
          },
          server = {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              on_attach(client, bufnr)

              local options = { silent = true, buffer = bufnr }
              -- Code action groups
              keymap.set("n", "<leader>ca", function()
                vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
              end, options)

              -- Hover actions
              keymap.set("n", "K", function()
                vim.cmd.RustLsp({ "hover", "actions" })
              end, options)
            end,
            default_settings = {
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
          -- for debugger
          dap = {
            adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
      elseif server == "lua_ls" then
        -- configure lua server (with special settings)
        lspconfig["lua_ls"].setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            -- keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
            -- keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
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
            -- keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
            -- keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
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
            -- keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
            -- keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
          end,
        })
      end
    end
  end,
}
