local null_ls = require("null-ls")
local diagnostics = null_ls.builtins.diagnostics

local M = {}

function M.setup()
  -- configure null_ls
  null_ls.setup({
    -- debug = true, -- enable debug mode and get debug output
    sources = {
      diagnostics.yamllint, -- yaml linter configuration of yamllint: https://yamllint.readthedocs.io/en/stable/configuration.html

      require("none-ls-shellcheck.diagnostics"), -- shell linter
      require("none-ls-shellcheck.code_actions"), -- shell code action

      require("none-ls.diagnostics.ruff"), -- python linter

      diagnostics.selene.with({ -- lua linter
        condition = function(utils)
          return utils.root_has_file({ "selene.toml" })
        end,
      }),

      diagnostics.editorconfig_checker.with({ -- a tool to verify with .editorconfig
        disabled_filetypes = { "erlang", "markdown", "python", "vrl" }, -- disable editorconfig checker
      }),

      diagnostics.hadolint, -- dockerfile linter

      diagnostics.fish, -- basic linting is available for fish scripts

      -- diagnostics.sqlfluff.with({
      --   extra_args = { "--dialect", "mysql" }, -- change to your dialect
      -- }),
    },
  })
end

return M
