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
  hijack_cursor = true,
  system_open = {
    cmd = "open",
  },
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
      show = {
        git = true,
        file = false,
        folder = false,
        folder_arrow = true,
      },
      git_placement = "after",
      glyphs = {
        bookmark = "🔖",
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "⌥",
          renamed = "➜",
          untracked = "★",
          deleted = "⊖",
          ignored = "◌",
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
