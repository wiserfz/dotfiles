local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ","
vim.g.localleader = "\\"

-- Remove trailing spaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

require("lazy").setup({
  {
    "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  },
  {
    "RRethy/vim-illuminate", -- highlight other uses of word under cursor
  },
  {
    "j-hui/fidget.nvim", -- provide a UI for nvim-lsp's progress handler
  },
  {
    "mbledkowski/neuleetcode.vim",
  },
  { import = "plugins" },
  { import = "plugins.lsp" },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
