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
local on_attach = function(client, bufnr)
  -- disable formatting for LSP clients as this is handled by null-ls
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  map("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  map("n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts) -- goto definition by lspsaga
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- goto definition by vim.lsp API
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- go to declaration, gopls and sumneko_lua lsp not support
  map("n", "gD", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
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

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure lua server (with special settings)
lspconfig["sumneko_lua"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
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

-- configure erlangls server
lspconfig["erlangls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

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
      on_attach = on_attach,
      standalone = true,
      settings = {
        ["rust-analyzer"] = {
          -- server = {
          --   extraEnv = {
          --     CHALK_OVERFLOW_DEPTH = "500",
          --     CHALK_SOLVER_MAX_SIZE = "100",
          --   },
          -- },
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

-- configure golang server
local go_status, go = pcall(require, "go")
if go_status then
  go.setup({
    -- NOTE: all LSP and formatting related options are disabeld.
    -- NOTE: LSP is handled by lsp.lua and formatting is handled by null-ls.lua
    -- NOTE: via `lsp_on_attach` the custom callback used by all other LSPs is called
    go = "go", -- go command, can be go[default] or go1.18beta1
    goimport = "gopls", -- goimport command, can be gopls[default] or goimport
    fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
    gofmt = "gofumpt", -- gofmt cmd,
    max_line_len = 128, -- max line length in golines format, Target maximum line length for golines
    tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
    tag_options = "json=omitempty", -- sets options sent to gomodifytags, i.e., json=omitempty
    gotests_template = "", -- sets gotests -template parameter (check gotests for details)
    gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
    comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. ﳑ       
    icons = { breakpoint = "🧘", currentpos = "🏃" }, -- setup to `false` to disable icons setup
    verbose = false, -- output loginf in messages
    lsp_cfg = {
      capabilities = capabilities,
    }, -- true: use non-default gopls setup specified in go/lsp.lua
    -- false: do nothing
    -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
    -- lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
    lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
    lsp_on_attach = on_attach, -- nil: use on_attach function defined in go/lsp.lua,
    -- when lsp_cfg is true
    -- if lsp_on_attach is a function: use this function as on_attach function for gopls
    lsp_codelens = true, -- set to false to disable codelens, true by default
    lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
    lsp_diag_hdlr = true, -- hook lsp diag handler
    lsp_diag_underline = false,
    -- virtual text setup
    lsp_diag_virtual_text = { space = 0, prefix = "" },
    lsp_diag_signs = true,
    lsp_diag_update_in_insert = true,
    lsp_document_formatting = false, -- true: use gopls to format, false: use other formatter tool
    lsp_inlay_hints = {
      enable = true,
      -- Only show inlay hints for the current line
      only_current_line = false,
      -- Event which triggers a refersh of the inlay hints.
      -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
      -- not that this may cause higher CPU usage.
      -- This option is only respected when only_current_line and
      -- autoSetHints both are true.
      only_current_line_autocmd = "CursorHold",
      -- whether to show variable name before type hints with the inlay hints or not
      -- default: false
      show_variable_name = true,
      -- prefix for parameter hints
      parameter_hints_prefix = " ",
      show_parameter_hints = true,
      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = "=> ",
      -- whether to align to the lenght of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 6,
      -- The color of the hints
      highlight = "Comment",
    },
    gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
    gopls_remote_auto = true, -- add -remote=auto to gopls
    gocoverage_sign = "█",
    sign_priority = 5, -- change to a higher number to override other signs
    dap_debug = true, -- set to false to disable dap
    dap_debug_keymap = false, -- true: use keymap for debugger defined in go/dap.lua
    -- false: do not use keymap in go/dap.lua.  you must define your own.
    dap_debug_gui = true, -- bool|table put your dap-ui setup here, set to false to disable
    dap_debug_vt = false, -- set to true to enable dap virtual text
    dap_port = -1, -- can be set to a number, if set to -1 go.nvim will pickup a random port
    dap_timeout = 15, --  see dap option initialize_timeout_sec = 15,
    dap_retries = 20, -- see dap option max_retries
    build_tags = "", --textobjects = true, -- enable default text jobects through treesittter-text-objects
    test_runner = "go", -- richgo, go test, richgo, dlv, ginkgo
    run_in_floaterm = false, -- set to true to run in float window. set default build tags
    -- float term recommend if you use richgo/ginkgo with terminal color
    trouble = true, -- true: use trouble to open quickfix
  })
end
