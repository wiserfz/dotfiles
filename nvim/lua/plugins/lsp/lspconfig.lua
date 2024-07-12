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
    "nvim-lua/lsp-status.nvim",
  },
  config = function()
    -- set lsp log level to error
    vim.lsp.set_log_level("ERROR")

    local lspconfig = require("lspconfig")
    local lsp_status = require("lsp-status")

    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
    -- Status config
    lsp_status.config({
      status_symbol = "  LSP:",
      indicator_errors = signs.Error,
      indicator_warnings = signs.Warn,
      indicator_info = signs.Info,
      indicator_hint = signs.Hint,
      indicator_ok = "",
      current_function = false,
    })

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
        settings = { -- custom settings for lua
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            -- make the language server recognize "vim" global
            diagnostics = {
              enable = true,
              globals = {
                "vim",
                "Color",
                "c",
                "Group",
                "g",
                "s",
                "describe",
                "it",
                "before_each",
                "after_each",
                "use",
              },
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
            hint = {
              enable = true,
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
      dockerls = {
        settings = {
          docker = {
            languageserver = {
              formatter = {
                ignoreMultilineInstructions = true,
              },
            },
          },
        },
      },
      markdown_oxide = {},
      -- erlangls = {},
    }

    local disable = function() end
    -- Special server configurations
    local special_servers = {
      rust_analyzer = disable, -- Setup in rust.lua
      gopls = disable, -- Setup in go.lua
    }

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
    -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
    capabilities.workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    }
    -- Add lsp_status capabilities
    capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)
    capabilities =
      vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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
          lsp_status.on_attach(client, bufnr)
          on_attach(client, bufnr)
          -- keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
          -- keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = bufnr })
        end,
      })
      lspconfig[server_name].setup(opts_with_capabilities)
    end

    -- Ensure that servers mentioned above get installed
    local ensure_installed =
      vim.list_extend(vim.tbl_keys(server_configs), vim.tbl_keys(special_servers))

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = ensure_installed,
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
      handlers = { setup },
    })
  end,
}
