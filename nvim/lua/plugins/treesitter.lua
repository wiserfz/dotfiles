-- treesitter configuration
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    -- "nvim-treesitter/nvim-treesitter-context",
    "andymass/vim-matchup",
    "windwp/nvim-ts-autotag",
  },

  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  event = "VeryLazy",
  config = function()
    -- import nvim-treesitter plugin safely
    local status, treesitter = pcall(require, "nvim-treesitter.configs")
    if not status then
      return
    end
    vim.filetype.add({
      extension = {
        inc = ".gitconfig",
      },
      filename = {
        ["gitconfig"] = ".gitconfig",
        ["gitignore"] = ".gitignore",
      },
      pattern = {
        [".*/\\.git/config"] = ".gitconfig",
        [".*/\\.git/info/exclude"] = ".gitignore",
      },
    })

    -- configure treesitter
    treesitter.setup({
      -- enable syntax highlighting
      highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = { enable = true },
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
        "erlang",
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
      },
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        disable_virtual_text = true,
        include_match_words = true,
      },
      -- context = {
      --   enable = true,
      --   min_window_height = 4,
      -- },
    })

    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
}
