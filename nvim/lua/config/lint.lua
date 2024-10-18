local lint = require("lint")
local util = require("util")

local codespell = lint.linters.codespell
codespell.args = {
  "--ignore-words-list",
  "crate",
  "--stdin-single-line",
  "-",
}

local M = {}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

function M.setup()
  codespell = require("lint.util").wrap(codespell, function(diagnostic)
    diagnostic.severity = vim.diagnostic.severity.WARN
    return diagnostic
  end)

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
      { severity = vim.diagnostic.severity.WARN, source = "editorconfig_checker" }
    ),
  }

  lint.linters_by_ft = {
    markdown = { "vale" },
    proto = { "buf_lint" },
    fish = { "fish" },
    yaml = { "yamllint" },
    sh = { "shellcheck" },
    python = { "ruff" },
    lua = { "selene" },
    dockerfile = { "hadolint" },
    sql = { "sqlfluff" },
  }

  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    group = lint_augroup,
    callback = function()
      local client = vim.lsp.get_clients({ bufnr = 0 })[1] or {}
      lint.try_lint(
        nil,
        { cwd = client.root_dir or vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h") }
      )
      lint.try_lint("codespell")
      -- WARN: This will lint all buffers(include NvimTree, help and so on), which is not a good idea
      lint.try_lint("editorconfig_checker")
    end,
  })

  -- util.map("n", "<leader>lc", function()
  --   lint.try_lint()
  -- end, { desc = "Trigger linting for current file" })
end

return M
