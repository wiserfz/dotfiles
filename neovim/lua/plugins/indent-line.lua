-- indent blankline

local status, indent_line = pcall(require, "indent_blankline")
if not status then
  return
end

-- Ident Lines
vim.cmd([[highlight IndentBlanklineIndent1 guifg=#2d3033 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#2d3033 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#2d3033 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#2d3033 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#2d3033 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#2d3033 gui=nocombine]])

indent_line.setup({
  char = "┊",
  -- char = " ",
  filetype_exclude = {
    "help",
    "dashboard",
    "packer",
    "NvimTree",
  },
  context_patterns = {
    "return",
    "^func",
    "fn",
    "^if",
    "^while",
    "^for",
    "block",
    "arguments",
    "if_statement",
    "else_clause",
    "try_statement",
    "catch_clause",
    "import_statement",
    "operation_type",
  },
  use_treesitter = true,
  use_treesitter_scope = true,
  show_first_indent_level = true,
  space_char_blankline = " ",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },
})
