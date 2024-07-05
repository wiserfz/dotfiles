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

-- trim trailing spaces
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

require("lazy").setup({
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  "RRethy/vim-illuminate", -- highlight other uses of word under cursor
  "HiPhish/rainbow-delimiters.nvim", -- rainbow parentheses
  {
    "norcalli/nvim-colorizer.lua", -- color highlighter
    config = function()
      require("colorizer").setup()
    end,
  },
  { import = "plugins.lsp" },
  { import = "plugins" },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
