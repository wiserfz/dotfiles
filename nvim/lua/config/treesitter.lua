local treesitter = require("nvim-treesitter")
local treesitter_config = require("nvim-treesitter.config")

local ensure_installed = {
  "asm",
  "cpp",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "bash",
  "lua",
  "dockerfile",
  "git_config",
  "gitignore",
  "gitattributes",
  "erlang",
  "fish",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "rust",
  "sql",
  "toml",
  "ini",
  "proto",
  "python",
  "sql",
  "jq",
  "tmux",
  "vrl",
  "regex",
  "query",
  "awk",
  "just",
  "mermaid",
  "requirements",
  "ssh_config",
  "textproto",
  "comment",
  "html",
  "vim",
  "vimdoc",
}

local syntax_highlight = {
  "erlang",
}

local M = {}

function M.setup()
  treesitter.install(ensure_installed)

  local available = treesitter_config.get_available()

  local function attach(bufnr, winnr)
    local max_filesize = 1000 * 1024 -- 1000 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
      return
    end

    vim.treesitter.start(bufnr) -- highlight
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
    vim.wo[winnr][0].foldexpr = "v:lua.vim.treesitter.foldexpr()" -- folds
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
    callback = function(ev)
      local bufnr, ft = ev.buf, ev.match
      local lang = vim.treesitter.language.get_lang(ft) or ft
      local winnr = vim.api.nvim_get_current_win()

      local ok = pcall(attach, bufnr, winnr)
      if not ok then
        if lang == "" or not vim.tbl_contains(available, lang) then
          return
        end
        treesitter.install(lang):await(function(_, installed)
          if installed then
            attach(bufnr, winnr)
          end
        end)
      end

      -- must be called after `attach` to ensure the language is set
      if vim.tbl_contains(syntax_highlight, lang) then
        vim.opt.syntax = "on"
      end
    end,
  })
end

return M
