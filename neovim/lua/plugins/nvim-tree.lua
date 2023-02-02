-- plugin of nvim-tree
local setup, tree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- change color for arrows in tree to white
vim.cmd([[ highlight NvimTreeIndentMarker guifg=white ]])

local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

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
