local keymap = vim.keymap

-- enable keybinds only for when lsp server available
local function on_attach(client, bufnr)
  -- disable formatting for LSP clients as this is handled by null-ls
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
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

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim", -- Integration with nvim-lspconfig
    "b0o/schemastore.nvim", -- YAML/JSON schemas
    "hrsh7th/cmp-nvim-lsp",
    {
      "folke/neodev.nvim",
      opts = {
        library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
      },
    },
  },
  config = function()
    local lspconfig = require("lspconfig")

    -- disable lsp log
    vim.lsp.set_log_level("off")

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Neovim Lua API completions/documentation
    require("neodev").setup({
      override = function(_, library)
        library.enabled = true
      end,
    })
    ---------------------------
    -- Server configurations --
    ---------------------------
    -- list of servers for mason to install
    local server_configs = {
      lua_ls = {
        -- on_init = function(client)
        --   local path = client.workspace_folders and client.workspace_folders[1].name
        --   -- if not has_file(path, { '.luarc.json', '.luarc.jsonc' }) then
        --   client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
        --     Lua = {
        --       completion = {
        --         callSnippet = "Replace",
        --         autoRequire = true,
        --       },
        --       format = {
        --         enable = true,
        --         defaultConfig = {
        --           indent_style = "space",
        --           indent_size = "2",
        --           max_line_length = "100",
        --           trailing_table_separator = "smart",
        --         },
        --       },
        --       diagnostics = {
        --         globals = { "vim", "it", "describe", "before_each", "are" },
        --       },
        --       hint = {
        --         enable = true,
        --         arrayIndex = "Disable",
        --       },
        --       workspace = {
        --         checkThirdParty = false,
        --       },
        --       telemetry = {
        --         enable = false,
        --       },
        --     },
        --   })
        --
        --   client.notify("workspace/didChangeConfiguration", {
        --     settings = client.config.settings,
        --   })
        --   -- end
        --   return true
        -- end,
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
      },
      -- YAML --
      yamlls = {
        settings = {
          yaml = {
            schemaStore = {
              url = "https://www.schemastore.org/api/json/catalog.json",
              enable = true,
            },
            customTags = {
              -- AWS CloudFormation tags
              "!Equals sequence",
              "!FindInMap sequence",
              "!GetAtt",
              "!GetAZs",
              "!ImportValue",
              "!Join sequence",
              "!Ref",
              "!Select sequence",
              "!Split sequence",
              "!Sub",
              "!Or sequence",
            },
          },
        },
      },
      -- Bash/Zsh --
      bashls = {
        filetypes = { "sh", "zsh" },
      },
      -- Json --
      jsonls = {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              -- Disable formatting diagnostics (that's what formatters are for)
              pylint = { enabled = false },
              pycodestyle = { enabled = false },
              pyflakes = { enabled = false },
            },
          },
        },
      },
      erlangls = {},
    }

    local disable = function() end
    -- Special server configurations
    local special_servers = {
      rust_analyzer = disable, -- Setup in rust.lua
      gopls = disable, -- Setup in go.lua
    }

    -- used to enable autocompletion (assign to every lsp server config)
    local cap = vim.lsp.protocol.make_client_capabilities()
    cap.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    local capabilities = vim.tbl_deep_extend("force", cap, require("cmp_nvim_lsp").default_capabilities())

    --------------------
    -- Set up servers --
    --------------------
    local function setup(server_name)
      local special_server_setup = special_servers[server_name]
      if special_server_setup then
        special_server_setup()
        return
      end

      local opts = server_configs[server_name] or {}
      local opts_with_capabilities = vim.tbl_deep_extend("force", opts, {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
          -- keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
        end,
      })
      lspconfig[server_name].setup(opts_with_capabilities)
    end

    -- Ensure that servers mentioned above get installed
    local ensure_installed = vim.list_extend(vim.tbl_keys(server_configs), vim.tbl_keys(special_servers))

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = ensure_installed,
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
      handlers = { setup },
    })
  end,
}
