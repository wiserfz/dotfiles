-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

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
    "vim",
    "dockerfile",
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
  },
  -- auto install above language parsers
  auto_install = true,
  rainbow = {
    enable = true,
    query = "rainbow-parens",
    max_file_lines = nil,
  },
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = {}, -- optional, list of language that will be disabled
  },
})
