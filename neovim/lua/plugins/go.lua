return {
  "ray-x/go.nvim",
  dependencies = { -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/cmp-nvim-lsp",
  },
  -- event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  -- build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  config = function()
    local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require("go.format").goimports()
      end,
      group = format_sync_grp,
    })

    local go = require("go")
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

    go.setup({
      lsp_cfg = {
        capabilities = capabilities,
      },
      lsp_on_attach = function(client, bufnr)
        lsp_status.on_attach(client, bufnr)
        -- keybind options
        local opts = { noremap = true, silent = true, buffer = bufnr }

        keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        keymap.set("n", "gf", "<cmd>Lspsaga finder def+ref<CR>", opts) -- show definition, references
        keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
        keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
        keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
        keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- code action for diagnostic
        keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side
      end,
      lsp_inlay_hints = {
        enable = false,
      },
    })
  end,
}
