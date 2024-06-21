return {
  "mrcjkb/rustaceanvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  version = "^4", -- Recommended
  lazy = false, -- This plugin is already lazy
  ft = { "rust" },
  config = function()
    local format_sync_grp = vim.api.nvim_create_augroup("RustaceanFormat", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      callback = function()
        vim.lsp.buf.format()
      end,
      group = format_sync_grp,
    })

    -- debugging rust by codelldb
    -- NOTE: install CodeLLDB via Mason, MasonInstall codelldb
    local mason_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/"
    local codelldb_path = mason_path .. "codelldb/extension/adapter/codelldb"
    local liblldb_path = mason_path .. "codelldb/extension/lldb/lib/liblldb.dylib"

    local lsp_status = require("lsp-status")
    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    -- Add lsp_status capabilities
    capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local keymap = vim.keymap
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
          lsp_status.on_attach(client, bufnr)
          -- keybind options
          local opts = { noremap = true, silent = true, buffer = bufnr }

          keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
          keymap.set("n", "gf", "<cmd>Lspsaga finder def+ref<CR>", opts) -- show definition, references
          keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
          keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
          keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
          keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side
          -- Code action groups
          keymap.set("n", "<leader>ca", function()
            vim.cmd.RustLsp("codeAction") -- supports rust-analyzer's grouping
          end, opts)

          -- Hover actions
          keymap.set("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, opts)
        end,
        default_settings = {
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            checkOnSave = true,
            check = {
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
  end,
}
