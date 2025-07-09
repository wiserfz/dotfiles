local conform = require("conform")
local wk = require("which-key")

local M = {}

---WARN: diagnostic error see: https://github.com/LuaLS/lua-language-server/issues/2035
---@param self string @The string suffix is ending or not
---@diagnostic disable-next-line: duplicate-set-field
function string:suffix(ending)
  return ending == "" or self:sub(-#ending) == ending
end

function M.setup()
  conform.setup({
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      proto = { "buf" },
      yaml = { "yamlfmt" }, -- https://github.com/google/yamlfmt/blob/main/docs/config-file.md
      sh = { "shfmt" },
      lua = { "stylua" },
      fish = { "fish_indent" },
      sql = { "sqlfmt" },
      json = { "jq" },
      python = { "ruff_format" },
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
      erlang = { "erlfmt" },
      markdown = { "injected" },
      query = { "format-queries" },
      ["_"] = { "trim_whitespace", "trim_newlines" },
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
          default_edition = "2024",
        },
      },
    },
    format_on_save = function(bufnr)
      local trim_formatters = {
        timeout_ms = 5000,
        formatters = { "trim_whitespace", "trim_newlines" },
      }

      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { "rust", "erlang" }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return trim_formatters
      end

      -- Disable autoformat for file has certain suffix
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:suffix("lazy-lock.json") then
        return trim_formatters
      end

      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return trim_formatters
      end

      -- Disable autoformat for files in a certain path
      -- local bufname = vim.api.nvim_buf_get_name(bufnr)
      -- if bufname:match("/target/") then
      --   return trim_whitespace
      -- end

      return { timeout_ms = 5000, lsp_format = "fallback" }
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

  wk.add({
    {
      "gqq",
      function()
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
      end,
      mode = { "n", "v" },
      desc = "Format code",
    },
  })
end

return M
