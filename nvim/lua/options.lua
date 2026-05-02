local api = vim.api
local M = {}

function M.setup()
  vim.g.mapleader = ","
  vim.g.localleader = "\\"

  vim.g.t_Co = 256

  -- Recommended settings from nvim-tree documentation
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- Visuals
  vim.opt.signcolumn = "yes:2" -- str: 显示符号栏
  vim.opt.number = true -- bool: Show line numbers
  vim.opt.relativenumber = true -- bool: Show relative line numbers
  vim.opt.linebreak = true
  vim.opt.breakindent = true
  vim.opt.wrap = true
  vim.opt.scrolloff = 4 -- int: Min num lines of context
  vim.opt.background = "dark"

  -- Indentation, tabs & whitespace
  vim.opt.autoindent = true
  vim.opt.smarttab = true
  vim.opt.expandtab = true -- bool: Use spaces instead of tabs
  vim.opt.shiftwidth = 4 -- int:  Size of an indent
  vim.opt.softtabstop = 4 -- int:  Number of spaces tabs count for in insert mode
  vim.opt.tabstop = 4 -- int: Tab character show the amount of space

  vim.opt.backspace = "indent,eol,start"

  -- Search
  vim.opt.incsearch = true -- bool: Use incremental search
  vim.opt.ignorecase = true -- bool: Ignore case in search patterns
  vim.opt.smartcase = true -- bool: Override ignorecase if search contains capitals
  vim.opt.hlsearch = true -- bool: Highlight search matches
  vim.opt.showmatch = true
  vim.opt.gdefault = true

  -- Split
  vim.opt.laststatus = 3 -- show just one status line
  vim.opt.splitright = true
  vim.opt.splitbelow = true

  -- Cursor & Mouse & Words
  vim.opt.cursorline = true -- bool: Current line highlight
  vim.opt.cursorlineopt = "both"
  vim.opt.colorcolumn = "100" -- str: Show col for max line length
  vim.opt.mouse = "a" -- str: Enable mouse mode
  vim.opt.mousemoveevent = true
  vim.opt.iskeyword:append("-") -- Make 'a-b' as a word

  -- Appearance
  vim.opt.syntax = "on" -- str:  Allow syntax highlighting
  vim.opt.termguicolors = true -- bool: If term supports ui color then enable
  vim.opt.pumheight = 10 -- maximum number of items to show in the popup window

  -- File
  vim.opt.undofile = true -- bool: Save undo history
  vim.opt.encoding = "utf-8" -- str:  String encoding to use
  -- opt.ambiwidth = "double"
  vim.opt.fileencodings = "utf-8,gb18030,gbk,gb2312,ucs-bom,cp936,latin1" -- str: Attempt to recognize file encoding to use
  vim.opt.fileformat = "unix" -- str:  Line breaks use unix

  -- Splits
  vim.opt.splitright = true -- bool: Place new window to right of current one
  vim.opt.splitbelow = true -- bool: Place new window below the current one

  -- Clipboard
  vim.opt.clipboard:append("unnamedplus")

  -- Folding by ufo
  -- Hide foldcolumn for transparency
  -- See https://github.com/kevinhwang91/nvim-ufo/issues/4
  vim.opt.foldcolumn = "1"
  vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true
  vim.opt.fillchars = {
    eob = " ",
    fold = " ",
    foldopen = "",
    foldsep = " ",
    foldclose = "",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
  }

  vim.filetype.add({
    extension = {
      inc = "gitconfig",
      vrl = "vrl",
    },
    filename = {
      ["gitconfig"] = "gitconfig",
      ["gitignore"] = "gitignore",
      ["rebar.config"] = "erlang",
      ["elvis.config"] = "erlang",
    },
    pattern = {
      [".*/%.git/config"] = "gitconfig",
      [".*/%.git/info/exclude"] = "gitignore",
      [".*/sys.*%.config.*"] = "erlang",
      [".*/.*%.app%.src"] = "erlang",
    },
  })

  local user_group = api.nvim_create_augroup("user.options", { clear = true })

  -- Highlight yanked text
  api.nvim_create_autocmd("TextYankPost", {
    group = user_group,
    callback = function()
      vim.highlight.on_yank({ on_visual = false, timeout = 150 })
    end,
  })

  -- Split help window to the right
  api.nvim_create_autocmd("FileType", {
    group = user_group,
    pattern = "help",
    callback = function()
      vim.opt_local.bufhidden = "unload"
      vim.cmd.wincmd("L")
      vim.api.nvim_win_set_width(0, 90)
    end,
  })

  -- Git commit spell checking
  api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    group = user_group,
    callback = function()
      vim.opt_local.spell = true
    end,
  })

  -- Toggle between relative/absolute line numbers
  api.nvim_create_autocmd(
    { "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" },
    {
      pattern = "*",
      group = user_group,
      callback = function()
        if vim.o.nu and api.nvim_get_mode().mode ~= "i" then
          vim.opt.relativenumber = true
        end
      end,
    }
  )

  api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
    pattern = "*",
    group = user_group,
    callback = function()
      if vim.o.nu then
        vim.opt.relativenumber = false
        vim.cmd.redraw()
      end
    end,
  })
end

return M
