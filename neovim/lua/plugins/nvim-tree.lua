-- plugin of nvim-tree
require("nvim-tree").setup()

local setup, tree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- change color for arrows in tree to white
vim.cmd([[ highlight NvimTreeIndentMarker guifg=white ]])

tree.setup()
