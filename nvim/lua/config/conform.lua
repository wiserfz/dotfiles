local conform = require("conform")
local util = require("util")

local M = {}

function M.setup()
  conform.setup({
    formatters_by_ft = {
      proto = { "buf" }, -- protocol buffer formatter
      yaml = { "yamlfmt" }, -- yaml formatter configuration of yamlfmt: https://github.com/google/yamlfmt/blob/main/docs/config-file.md
      sh = { "shfmt" }, -- shell parser and formatter
      lua = { "stylua" }, -- lua formatter
      fish = { "fish_indent" }, -- indenter and prettifier for fish code
      sql = { "sqlfmt" }, -- sql formatter
      json = { "jq" }, -- json formatter
      python = { "ruff_format" }, -- python formatter
      go = { "gofmt", "goimports" }, -- go formatter
      rust = { "rustfmt" }, -- rust formatter
      ["*"] = { "trim_whitespace" },
    },
    formatters = {
      shfmt = {
        append_args = { "-i", "4", "-bn", "-ci", "-sr" },
        options = {
          lang_to_ext = {
            bash = "sh",
          },
        },
      },
      sqlfmt = {
        exe = "sqlfmt",
        stdin = true,
        args = { "-", "--fast", "--line-length", "100", "--quiet", "--no-progressbar" },
      },
      rustfmt = {
        options = {
          default_edition = "2021",
        },
      },
    },
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      -- local ignore_filetypes = { "sql", "java" }
      -- if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      --   return
      -- end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      -- local bufname = vim.api.nvim_buf_get_name(bufnr)
      -- if bufname:match("/node_modules/") then
      --   return
      -- end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  })

  -- crate commands to enable/disable autoformat
  vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
      -- FormatDisable! will disable formatting just for this buffer
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, {
    desc = "Disable autoformat-on-save",
    bang = true,
  })
  vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, {
    desc = "Re-enable autoformat-on-save",
  })

  util.map("", "<leader>f", function()
    conform.format({ async = true }, function(err)
      if not err then
        local mode = vim.api.nvim_get_mode().mode
        if vim.startswith(string.lower(mode), "v") then
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
            "n",
            true
          )
        end
      end
    end)
  end, { desc = "Format code" })
end

return M
