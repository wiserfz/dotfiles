local tree = require("nvim-tree")
local util = require("util")

--@param data table @The data from the autocmd
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

--@param bufnr number @The client buffer number
local function _on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- your removals and mappings go here
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

local M = {}

function M.setup()
  -- change color for arrows in tree to white
  vim.cmd([[
    hi NvimTreeIndentMarker guifg=white
    hi NvimTreeExecFile guifg=#98bb6c gui=bold cterm=bold
    hi NvimTreeSpecialFile guifg=#CC484D gui=bold
    hi NvimTreeSymLink guifg=#C23BC4 gui=italic
    hi Directory guifg=#6A7C93 gui=bold
    hi NvimTreeGitDirty guifg=#6f99de gui=bold
  ]])

  vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

  tree.setup({
    view = {
      width = 35,
      -- relativenumber = true,
    },
    on_attach = _on_attach, -- see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach
    sort_by = "case_sensitive",
    hijack_cursor = true,
    system_open = {
      cmd = "open",
    },
    renderer = {
      group_empty = true,
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "go.mod" },
      highlight_git = "name",
      icons = {
        show = {
          git = true,
          file = true,
          folder = true,
          folder_arrow = true,
        },
        git_placement = "after",
        glyphs = {
          bookmark = "🔖",
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "⊖",
            ignored = "◌",
          },
        },
      },
    },
    -- disable window_picker for explorer to work well with window splits
    actions = {
      open_file = {
        window_picker = {
          enable = false,
        },
      },
    },
    filters = {
      dotfiles = false,
    },
    git = {
      enable = true,
      ignore = false,
    },
  })

  -- Toggle nvim-tree
  util.map("n", "<leader>x", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
end

return M
