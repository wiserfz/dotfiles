-- options
local opt = vim.opt

-- context
-- opt.colorcolumn = '90'           -- str: Show col for max line length
opt.mouse = "a"                  -- str: Enable mouse mode
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.number = true                -- bool: Show line numbers
opt.relativenumber = false       -- bool: Show relative line numbers
-- vim.api.nvim_set_hl(0, "LineNr", { cterm=nil, ctermfg='Gray', ctermbg=nil })
opt.scrolloff = 4                -- int: Min num lines of context
opt.cursorline = true            -- bool: Current line highlight
-- vim.api.nvim_set_hl(0, "CursorLine", { cterm=nil, ctermfg=nil, ctermbg='LightGrey' })
opt.iskeyword:append("-")        -- Make 'a-b' as a word

-- file
opt.undofile = true              -- bool: Save undo history
opt.encoding = 'utf8'            -- str:  String encoding to use
opt.ambiwidth = double
opt.fileencoding = 'utf8'        -- str:  File encoding to use
opt.fileformat = 'unix'          -- str:  Line breaks use unix

-- appearance
-- opt.signcolumn = "yes"           -- str: 显示符号栏
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable

-- search
opt.ignorecase = true            -- bool: Ignore case in search patterns
opt.smartcase = true             -- bool: Override ignorecase if search contains capitals
opt.incsearch = true             -- bool: Use incremental search
opt.hlsearch = true              -- bool: Highlight search matches
-- vim.api.nvim_set_hl(0, "Search", { cterm=nil, ctermfg='Black', ctermbg='Blue' })

-- tabs & whitespace
opt.expandtab = false            -- bool: Use spaces instead of tabs
opt.shiftwidth = 4               -- int:  Size of an indent
opt.softtabstop = 4              -- int:  Number of spaces tabs count for in insert mode
opt.tabstop = 4                  -- int: Tab character show the amount of space
opt.smarttab = true
opt.autoindent = true
opt.backspace = "indent,eol,start"

-- splits
opt.splitright = true            -- bool: Place new window to right of current one
opt.splitbelow = true            -- bool: Place new window below the current one

-- clipboard
opt.clipboard:append("unnamedplus")
