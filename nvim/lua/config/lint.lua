local lint = require("lint")

local M = {}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

function M.setup()
  lint.linters.editorconfig_checker = {
    cmd = "editorconfig-checker",
    stdin = false,
    ignore_exitcode = true,
    args = {
      "-no-color",
      "-ignore-defaults",
      "-exclude",
      "\\.py$|\\.erl$|^Cargo\\.lock$|\\.bak$",
    },
    parser = require("lint.parser").from_pattern(
      "%s*(%d+): (.+)",
      { "lnum", "message" },
      nil,
      { severity = vim.diagnostic.severity.WARN, source = "editorconfig-checker" }
    ),
  }

  -- local sqlfluff = lint.linters.sqlfluff
  -- sqlfluff.args = {
  --   "lint",
  --   "--format=json",
  --   -- note: users will have to replace the --dialect argument accordingly
  --   "--dialect=mysql",
  -- }

  lint.linters_by_ft = {
    fish = { "fish" },
    yaml = { "yamllint" },
    -- python = { "ruff" },
    lua = { "selene" },
    -- dockerfile = { "hadolint" },
    sql = { "sqlfluff" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
    group = lint_augroup,
    ---@param args table see `:h event-args`
    callback = function(args)
      -- Only run the linter in buffers that you can modify and filetype is not empty
      -- in order to avoid superfluous noise, notably within the handy LSP pop-ups that
      -- describe the hovered symbol using Markdown.
      if vim.opt_local.modifiable:get() and vim.bo.filetype ~= "" then
        lint.try_lint()
        lint.try_lint("editorconfig_checker")
      end
    end,
  })
end

return M
