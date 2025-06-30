local treesitter = require("nvim-treesitter.configs")

local M = {}

function M.setup()
  treesitter.setup({
    -- enable syntax highlighting
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = function(_lang, buf)
        local max_filesize = 300 * 1024 -- 100 KB
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
