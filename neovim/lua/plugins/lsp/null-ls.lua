-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
  vim.notify("null-ls not found")
  return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
-- local code_actions = null_ls.builtins.code_actions -- to setup code actions
-- local completion = null_ls.builtins.completion -- to setup completion
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure null_ls
null_ls.setup({
  -- debug = true, -- enable debug mode and get debug output
  -- setup builtins sources for null-ls
  sources = {
    -- to disable file types use
    -- "formatting.prettier.with({disabled_filetypes = {}})" (see null-ls docs)
    formatting.stylua, -- lua formatter
    formatting.buf, -- protocol buffer formatter
    -- formatting.yamlfmt, -- yaml formatter
    formatting.sql_formatter, -- sql formatter
    formatting.jq, -- json formatter
    formatting.beautysh, -- shell formatter
    formatting.erlfmt, -- erlang formatter
    -- formatting.black, -- more popular python formatter
    formatting.autopep8, -- python formatter
    -- formatting.rustfmt, -- rust formatter
    -- code_actions.cspell, -- spell checker
    -- diagnostics.cspell, -- spell checker
    diagnostics.shellcheck, -- shell script static analysis tool
    -- a tool to verify with .editorconfig, need install ec command
    -- see release: https://github.com/editorconfig-checker/editorconfig-checker/releases
    diagnostics.editorconfig_checker.with({
      disabled_filetypes = { "erlang", "markdown", "python" }, -- disable editorconfig checker
    }),
    -- configuration of yamllint: https://yamllint.readthedocs.io/en/stable/configuration.html
    diagnostics.yamllint, -- yaml linter
    diagnostics.buf, -- working with Protocol Buffers
    diagnostics.fish, -- basic linting is available for fish scripts
    diagnostics.pylint, -- static code analysis for python
  },
  -- configure format on save
  on_attach = function(current_client, bufnr)
    if current_client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function(client)
              --  only use null-ls for formatting instead of lsp server
              return client.name == "null-ls"
            end,
            bufnr = bufnr,
          })
        end,
      })
    end
  end,
})

-- crates
local crates_status, crates = pcall(require, "crates")

if not crates_status then
  return
end

-- crates.setup({
--   null_ls = {
--     enabled = true,
--     name = "crates.nvim",
--   },
-- })

local function show_documentation()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand("<cword>"))
  elseif vim.fn.expand("%:t") == "Cargo.toml" and crates.popup_available() then
    crates.show_popup()
  else
    vim.lsp.buf.hover()
  end
end

local opts = { noremap = true }

vim.keymap.set("n", "K", show_documentation, opts)
vim.keymap.set("n", "<leader>ct", crates.toggle, opts)
vim.keymap.set("n", "<leader>cr", crates.reload, opts)

vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
vim.keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)

vim.keymap.set("n", "<leader>cu", crates.update_crate, opts)
vim.keymap.set("v", "<leader>cu", crates.update_crates, opts)
vim.keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, opts)
vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, opts)
vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, opts)

-- open offical homepage with brower
vim.keymap.set("n", "<leader>cH", crates.open_homepage, opts)
-- open github.com with browser
vim.keymap.set("n", "<leader>cR", crates.open_repository, opts)
-- open docs.rs with browser
vim.keymap.set("n", "<leader>cD", crates.open_documentation, opts)
-- open crate.io with browser
vim.keymap.set("n", "<leader>cC", crates.open_crates_io, opts)
