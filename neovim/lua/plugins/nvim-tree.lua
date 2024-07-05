-- filesystem navigation
return {
  "nvim-tree/nvim-tree.lua", -- file explorer
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- for file icons
  },
  config = function()
    local setup, tree = pcall(require, "nvim-tree")
    if not setup then
      return
    end

    -- change color for arrows in tree to white
    vim.cmd([[
      hi NvimTreeIndentMarker guifg=white
    ]])

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
        ignore = false,
      },
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    -- Toggle nvim-tree
    keymap.set("n", "<leader>fe", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
  end,
}
