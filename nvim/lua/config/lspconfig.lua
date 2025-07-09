local lspconfig = require("lspconfig")
local blink = require("blink.cmp")
local wk = require("which-key")
local mason_lspconfig = require("mason-lspconfig")
local schemastore = require("schemastore")
local util = require("util")

local disable = function() end
-- Special server configurations
local special_servers = {
  rust_analyzer = disable, -- Setup in rust.lua
  gopls = disable, -- Setup in go.lua
}

local M = {}

---@return table @Capabilities for LSP clients
function M.get_capabilities()
  -- used to enable autocompletion (assign to every lsp server config)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())

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

---@param client vim.lsp.Client @The client that was attached
---@param bufnr integer @The buffer number of the attached client
function M.on_attach(client, bufnr)
  -- disable formatting for LSP clients as this is handled by confrom
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  wk.add({
    buffer = bufnr,
    -- set keybinds
    -- WARN: lspsage goto_definition work with ufo has problem
    -- { "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "LSP definition" },
    { "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "LSP definition" },
    { "gD", "<cmd>Lspsaga peek_definition<cr>", desc = "LSP peek_definition" },
    { "gf", "<cmd>Lspsaga finder def+ref<cr>", desc = "Lspsaga finder" },
    { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "LSP implementation" },
    { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code action" },
    { "<leader>rn", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
    { "<leader>e", "<cmd>Lspsaga show_cursor_diagnostics<cr>", desc = "Current diagnostics" },
    { "[e", "<cmd>Lspsaga diagnostic_jump_prev<cr>", desc = "Previous diagnostic" },
    { "]e", "<cmd>Lspsaga diagnostic_jump_next<cr>", desc = "Next diagnostic" },
    { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover actions" },
    { "<leader>o", "<cmd>Lspsaga outline<cr>", desc = "Lspsaga outline" },
  })
end

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
          disable = {
            "missing-fields",
          },
          globals = {
            "vim",
            "require",
          },
          -- disable = { "missing-parameters", "missing-fields" },
        },
        workspace = {
          checkThirdParty = false,
          -- make language server aware of runtime files
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
            vim.fn.stdpath("config") .. "/lua",
            "${3rd}/luv/library",
          },
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
          url = "",
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
  buf_ls = {}, -- for protobuf
  just = {},
  elp = {}, -- for erlang
  harper_ls = { -- Grammar Checker
    on_attach = function(client, bufnr)
      if vim.fs.dirname(vim.fn.getcwd()) == os.getenv("HOME") .. "/Workspace" then
        vim.lsp.stop_client(client.id)
        return
      end
      M.on_attach(client, bufnr)
    end,
    settings = {
      ["harper-ls"] = {
        userDictPath = vim.fn.getcwd() .. "/.harper_dict.txt",
        fileDictPath = vim.fn.getcwd() .. "/.harper_dictionaries",
        diagnosticSeverity = "hint", -- Can also be "information", "warning", or "error"
        markdown = {
          IgnoreLinkTitle = true,
        },
        linters = {
          SpellCheck = true,
          SentenceCapitalization = false,
        },
      },
    },
  },
  clangd = { -- for c and cpp
    filetypes = { "h", "c", "cpp", "cc", "objc", "objcpp" },
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern(
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
      ".git",
      "Makefile"
    ),
  },
}

function M.setup()
  -- set lsp log level to error
  vim.lsp.set_log_level("ERROR")

  -- Change the Diagnostic symbols in the sign column (gutter)
  local diagnostics_text = {}
  local diagnostics_numhl = {}
  for type, icon in pairs(util.diagnostics) do
    diagnostics_text[vim.diagnostic.severity[type]] = icon
    diagnostics_numhl[vim.diagnostic.severity[type]] = ""
  end
  vim.diagnostic.config({
    signs = {
      text = diagnostics_text,
      numhl = diagnostics_numhl,
    },
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
    local opts_with_capabilities = vim.tbl_deep_extend("keep", opts, {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        M.on_attach(client, bufnr)
      end,
    })

    vim.lsp.config(server_name, opts_with_capabilities)
  end

  -- Ensure that servers mentioned above get installed
  local special_servers_name = vim.tbl_keys(special_servers)
  local ensure_installed = vim.list_extend(vim.tbl_keys(server_configs), special_servers_name)

  for _, server_name in ipairs(ensure_installed) do
    setup(server_name)
  end

  mason_lspconfig.setup({
    ensure_installed = ensure_installed,
    automatic_enable = {
      exclude = special_servers_name,
    },
  })
end

return M
