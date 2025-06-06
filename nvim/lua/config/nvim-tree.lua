local tree = require("nvim-tree")
local api = require("nvim-tree.api")
local wk = require("which-key")

---@param data table @The data from the autocmd
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

---@param bufnr number @The client buffer number
local function _on_attach(bufnr)
  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
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
    hi NvimTreeGitDirty guifg=#e9934d gui=bold cterm=bold
    hi NvimTreeGitNew guifg=#6f99de  gui=bold
    hi link NvimTreeHiddenIcon Comment
  ]])

  vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

  tree.setup({
    view = {
      width = 35,
      -- relativenumber = true,
    },
    sort_by = "case_sensitive",
    hijack_cursor = true,
    system_open = {
      cmd = "open",
    },
    renderer = {
      group_empty = false,
      highlight_hidden = "name",
      special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "go.mod" },
      highlight_git = "name",
      icons = {
        show = {
          git = true,
          file = true,
          folder = true,
          folder_arrow = true,
          hidden = false,
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
  wk.add({
    { "<leader>x", api.tree.toggle, desc = "File explorer" },
    {
      "<leader>X",
      function()
        api.tree.toggle({ find_file = true })
      end,
      desc = "File explorer current file",
    },
  })
end

return M
