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
}

local M = {}

function M.setup()
  treesitter.install(ensure_installed)

  local available = treesitter_config.get_available()

  local installed_cache = {}
  for _, parser in ipairs(treesitter_config.installed_parsers()) do
    installed_cache[parser] = true
  end

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
      local winnr = vim.api.nvim_get_current_win()

      -- auto-install missing parsers
      if installed_cache[ft] == nil then
        if not vim.tbl_contains(available, ft) then
          installed_cache[ft] = false
          return
        end

        treesitter.install(ft):await(function()
          installed_cache[ft] = true
          attach(bufnr, winnr)
        end)
      elseif installed_cache[ft] then
        attach(bufnr, winnr)
      end
    end,
  })

  treesitter_config.setup({
    matchup = {
      enable = true,
      disable_virtual_text = true,
      include_match_words = true,
    },
  })
end

return M
