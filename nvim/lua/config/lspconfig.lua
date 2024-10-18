local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsp_status = require("lsp-status")
local neodev = require("neodev")
local util = require("util")
local mason_lspconfig = require("mason-lspconfig")
local schemastore = require("schemastore")

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
          enable = false,
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
          -- disable = { "missing-parameters", "missing-fields" },
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
        schemas = schemastore.yaml.schemas({
          replace = {
            ["gitlab-ci"] = {
              description = "GitLab CI Schema before version v15.0.0",
              fileMatch = ".gitlab-ci.yml",
              name = "gitlab-ci",
              url = "https://gitlab.com/gitlab-org/gitlab/-/raw/v14.10.5-ee/app/assets/javascripts/editor/schema/ci.json",
            },
          },
        }),
        schemaStore = {
          enable = false,
          -- url = "https://www.schemastore.org/api/json/catalog.json",
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
        schemas = schemastore.json.schemas(),
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
  elp = {}, -- for erlang
}

local disable = function() end
-- Special server configurations
local special_servers = {
  rust_analyzer = disable, -- Setup in rust.lua
  gopls = disable, -- Setup in go.lua
}

local M = {}

--@return table @Capabilities for LSP clients
function M.get_capabilities()
  -- used to enable autocompletion (assign to every lsp server config)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Add lsp_status capabilities
  capabilities = vim.tbl_extend("force", capabilities, lsp_status.capabilities)
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())

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
  return capabilities
end

---@param client lsp.Client @The client that was attached
---@param bufnr integer @The buffer number of the attached client
function M.on_attach(client, bufnr)
  -- keybind options
  local opts = { buffer = bufnr }

  -- set keybinds
  -- WARN: lspsage goto_definition work with ufo has problem
  -- util.map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
  util.map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  util.map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  util.map("n", "gf", "<cmd>Lspsaga finder def+ref<CR>", opts) -- show definition, references
  util.map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  util.map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  util.map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  -- util.map.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
  util.map("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  util.map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  util.map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  util.map("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  util.map("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side
  -- util.map({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>") -- float terminal option-d
end

function M.setup()
  -- set lsp log level to error
  vim.lsp.set_log_level("ERROR")

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
  neodev.setup({
    override = function(_, library)
      library.enabled = true
    end,
  })

  -- Client capabilities
  local capabilities = M.get_capabilities()

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
        -- disable formatting for LSP clients as this is handled by none-ls
        -- client.server_capabilities.documentFormattingProvider = false
        -- client.server_capabilities.documentRangeFormattingProvider = false

        lsp_status.on_attach(client)
        M.on_attach(client, bufnr)
      end,
    })
    lspconfig[server_name].setup(opts_with_capabilities)
  end

  -- Ensure that servers mentioned above get installed
  local ensure_installed =
    vim.list_extend(vim.tbl_keys(server_configs), vim.tbl_keys(special_servers))

  mason_lspconfig.setup({
    ensure_installed = ensure_installed,
    -- auto-install configured servers (with lspconfig)
    automatic_installation = true, -- not the same as ensure_installed
    handlers = { setup },
  })
end

return M
