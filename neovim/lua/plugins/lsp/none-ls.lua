-- formatting & linting
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "gbprod/none-ls-shellcheck.nvim",
  },
  config = function()
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
      sources = {
        diagnostics.alex, -- markdown written
        diagnostics.codespell.with({ -- common misspellings checker
          extra_args = { "-L", "crate" }, -- comma separated list of words to ignore
        }),

        formatting.buf, -- protocol buffer formatter
        diagnostics.buf, -- protocol buffer linter

        formatting.yamlfmt, -- yaml formatter configuration of yamlfmt: https://github.com/google/yamlfmt/blob/main/docs/config-file.md
        diagnostics.yamllint, -- yaml linter configuration of yamllint: https://yamllint.readthedocs.io/en/stable/configuration.html

        require("none-ls-shellcheck.diagnostics"), -- shell linter
        require("none-ls-shellcheck.code_actions"), -- shell code action
        formatting.shfmt.with({ -- shell parser and formatter
          extra_args = { "-i", "4", "-ci", "-sr" },
        }),

        require("none-ls.formatting.ruff_format"), -- python formatter
        require("none-ls.diagnostics.ruff"), -- python linter

        formatting.stylua.with({ -- lua formatter
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
        }),
        diagnostics.selene.with({ -- lua linter
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" })
          end,
        }),

        diagnostics.editorconfig_checker.with({ -- a tool to verify with .editorconfig
          disabled_filetypes = { "erlang", "markdown", "python" }, -- disable editorconfig checker
        }),

        diagnostics.hadolint, -- dockerfile linter

        diagnostics.fish, -- basic linting is available for fish scripts
        formatting.fish_indent, -- indenter and prettifier for fish code

        -- diagnostics.sqlfluff.with({
        --   extra_args = { "--dialect", "mysql" }, -- change to your dialect
        -- }),
        -- formatting.sqlfluff.with({
        --   extra_args = { "--dialect", "mysql" }, -- change to your dialect
        -- }),

        -- formatting.erlfmt, -- erlang formatter

        require("none-ls.formatting.jq"), -- json formatter
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
  end,
}
