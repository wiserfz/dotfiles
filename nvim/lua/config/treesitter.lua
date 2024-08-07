local treesitter = require("nvim-treesitter.configs")

local M = {}

function M.setup()
  treesitter.setup({
    -- enable syntax highlighting
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = function(_lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      -- enable vim syntax highlighting for erlang
      additional_vim_regex_highlighting = { "erlang" },
    },
    -- enable indentation
    indent = { enable = true },
    -- ensure these language parsers are installed
    ensure_installed = {
      "json",
      "yaml",
      "markdown",
      "markdown_inline",
      "bash",
      "lua",
      "dockerfile",
      "git_config",
      "gitignore",
      -- "erlang",
      "fish",
      "go",
      "gomod",
      "gosum",
      "rust",
      "sql",
      "toml",
      "ini",
      "proto",
      "python",
      "sql",
      "jq",
      "printf",
      "tmux",
      "vrl",
    },
    -- disable automatically install missing parsers when entering buffer
    auto_install = false,
    matchup = {
      enable = true, -- mandatory, false will disable the whole extension
      disable_virtual_text = true,
      include_match_words = true,
    },
  })
end

return M
