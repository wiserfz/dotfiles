-- options
local opt = vim.opt

-- context
opt.number = true -- bool: Show line numbers
opt.relativenumber = true -- bool: Show relative line numbers

opt.cursorline = true -- bool: Current line highlight
opt.cursorlineopt = "number"

-- opt.colorcolumn = '90'           -- str: Show col for max line length
opt.mouse = "a" -- str: Enable mouse mode
opt.mousemoveevent = true
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.scrolloff = 4 -- int: Min num lines of context
opt.iskeyword:append("-") -- Make 'a-b' as a word
opt.pumheight = 10 -- maximum number of items to show in the popup window

-- file
opt.undofile = true -- bool: Save undo history
opt.encoding = "utf8" -- str:  String encoding to use
-- opt.ambiwidth = "double"
opt.fileencoding = "utf8" -- str:  File encoding to use
opt.fileformat = "unix" -- str:  Line breaks use unix

-- appearance
opt.signcolumn = "yes" -- str: 显示符号栏
opt.syntax = "ON" -- str:  Allow syntax highlighting
opt.termguicolors = true -- bool: If term supports ui color then enable

-- search
opt.ignorecase = true -- bool: Ignore case in search patterns
opt.smartcase = true -- bool: Override ignorecase if search contains capitals
opt.incsearch = true -- bool: Use incremental search
opt.hlsearch = true -- bool: Highlight search matches
-- vim.api.nvim_set_hl(0, "Search", { cterm=nil, ctermfg='Black', ctermbg='Blue' })

-- tabs & whitespace
opt.expandtab = true -- bool: Use spaces instead of tabs
opt.shiftwidth = 4 -- int:  Size of an indent
opt.softtabstop = 4 -- int:  Number of spaces tabs count for in insert mode
opt.tabstop = 4 -- int: Tab character show the amount of space
opt.smarttab = true
opt.autoindent = true
opt.backspace = "indent,eol,start"

-- setting indentation by filetype
-- lua
vim.cmd("autocmd FileType lua setlocal tabstop=2 shiftwidth=2 softtabstop=2")
-- yaml
vim.cmd("autocmd FileType yaml,yml setlocal tabstop=2 shiftwidth=2 softtabstop=2")
-- go
vim.cmd("autocmd FileType go setlocal noexpandtab")

-- splits
opt.splitright = true -- bool: Place new window to right of current one
opt.splitbelow = true -- bool: Place new window below the current one

-- clipboard
opt.clipboard:append("unnamedplus")

-- statusline
opt.laststatus = 3 -- show just one status line
