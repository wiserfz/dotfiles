-- Global variables

local g = vim.g

g.t_Co = 256
g.background = "dark"

-- recommended settings from nvim-tree documentation
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Update the packpath
local packer_path = vim.fn.stdpath("config") .. "/site"
vim.o.packpath = vim.o.packpath .. "," .. packer_path
