-- plugin of nvim-tree
local setup, tree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- change color for arrows in tree to white
vim.cmd([[ highlight NvimTreeIndentMarker guifg=white ]])

tree.setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = false,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
    icons = {
      git_placement = "after",
      glyphs = {
        git = {
          unstaged = "-",
          staged = "s",
          untracked = "u",
          renamed = "r",
          deleted = "d",
          ignored = "i",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  git = {
    ignore = false,
  },
})
