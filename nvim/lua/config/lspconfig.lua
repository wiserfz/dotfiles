-- local lspconfig = require("lspconfig")
local blink = require("blink.cmp")
local wk = require("which-key")
local mason_lspconfig = require("mason-lspconfig")
local schemastore = require("schemastore")
local util = require("util")

local disable = function()
  return true
end
-- Special server configurations
local special_servers = {
  rust_analyzer = disable, -- Setup in rust.lua
  gopls = disable, -- Setup in go.lua
  harper_ls = function()
    if vim.fs.dirname(vim.fn.getcwd()) == os.getenv("HOME") .. "/Workspace" then
      return true
    end
    return false
  end,
}

local exclude_servers = {
  -- NOTE: due to the ELP version management issue by mason, so exclude it from mason management
  -- use mise instead to install and manage elp version.
  -- see: https://github.com/mason-org/mason-registry/pull/10523
  "elp",
}

local filter_servers = function(name)
  if vim.tbl_contains(exclude_servers, name) then
    return false
  end
  return true
end

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
  -- client.server_capabilities.documentFormattingProvider = false
  -- client.server_capabilities.documentRangeFormattingProvider = false

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
            "unused-local",
          },
          globals = {
            "vim",
            "require",
          },
          -- disable = { "missing-parameters", "missing-fields" },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE:: library should now be handled by lazydev
          -- library = {
          --   vim.fn.expand("$VIMRUNTIME/lua"),
          --   vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          --   vim.fn.stdpath("config") .. "/lua",
          --   "${3rd}/luv/library",
          -- },
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
  ty = {}, -- python type checker and language server
  docker_language_server = {},
  fish_lsp = {},
  buf_ls = {}, -- for protobuf
  just = {},
  elp = { -- erlang type checker
    root_dir = vim.fs.root(0, { "rebar.config", ".git" }),
  },
  harper_ls = { -- Grammar Checker
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
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
      "--suggest-missing-includes",
    },
    root_dir = vim.fs.root(0, {
      ".clangd",
      ".clang-tidy",
      ".clang-format",
      "compile_commands.json",
      "compile_flags.txt",
      "configure.ac",
      ".git",
      "Makefile",
    }),
  },
  ts_query_ls = {
    filetypes = { "query" },
    root_dir = vim.fs.root(0, { "queries" }),
    settings = {
      parser_install_directories = {
        -- treesitter parser install path that nvim-treesitter main branch
        vim.fs.joinpath(vim.fn.stdpath("data"), "site", "parser"),
      },
    },
  },
  asm_lsp = {},
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
    if special_server_setup and special_server_setup() then
      return
    end

    local opts = server_configs[server_name] or {}
    local opts_with_capabilities = vim.tbl_deep_extend("keep", opts, {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        M.on_attach(client, bufnr)
      end,
    })

    if server_name == "elp" then
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers["window/showMessage"] = function(_, result, _)
        local notify_func = function(msg, level, options)
          local status_ok, fidget = pcall(require, "fidget")
          if status_ok then
            fidget.notify(msg, level, options)
          else
            vim.notify(msg, level)
          end
        end

        local level = result.type or vim.log.levels.INFO
        if string.match(result.message, "ELP version: .*, OTP version: .*") then
          local msg1 = string.gsub(result.message, "ELP version: (.*), OTP version: (.*)\n", "%1")
          local msg2 = string.gsub(result.message, "ELP version: (.*), OTP version: (.*)\n", "%2")
          notify_func(msg1, level, { skip_history = true, annote = "ELP" })
          notify_func(msg2, level, { skip_history = true, annote = "OTP" })
        else
          notify_func(result.message, level)
        end
      end
    end

    vim.lsp.config(server_name, opts_with_capabilities)
    -- Enable lsp server manually.
    vim.lsp.enable(server_name, true)
  end

  -- Ensure that servers mentioned above get installed
  local special_servers_name = vim.tbl_keys(special_servers)
  local installed_servers = vim.list_extend(vim.tbl_keys(server_configs), special_servers_name)
  for _, server_name in ipairs(installed_servers) do
    setup(server_name)
  end

  local ensure_installed = vim.tbl_filter(filter_servers, installed_servers)
  mason_lspconfig.setup({
    ensure_installed = ensure_installed,
    automatic_enable = false,
  })
end

return M
