-- fuzzy finding w/ telescope
return {
  "nvim-telescope/telescope.nvim", -- fuzzy finder
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- dependency for better sorting performance
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-media-files.nvim", -- image files preview in telescope
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-dap.nvim",
  },
  config = function()
    -- import telescope plugin safely
    local telescope_setup, telescope = pcall(require, "telescope")
    if not telescope_setup then
      return
    end

    -- import telescope actions safely
    local actions_setup, actions = pcall(require, "telescope.actions")
    if not actions_setup then
      return
    end

    -- configure telescope
    telescope.setup({
      -- configure custom mappings
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
          },
        },
        file_ignore_patterns = {
          "^.git/",
          "^target/",
          "LICENSE*",
        },
        layout_strategy = "vertical",
        layout_config = { height = 0.95, width = 0.95 },
      },
      extensions = {
        media_files = {
          -- filetypes whitelist
          -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
          filetypes = { "png", "webp", "jpg", "jpeg", "ppm", "pdf" },
          find_cmd = "rg", -- find command (defaults to `fd`)
        },
      },
    })

    -- load extension to support preview of media files
    telescope.load_extension("media_files")

    -- Get fzf loaded and working with extension
    telescope.load_extension("fzf")

    telescope.load_extension("dap")

    local keymap = vim.keymap
    local options = { noremap = true }

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", options) -- find files within current working directory, respects .gitignore
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", options) -- find string in current working directory as you type
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", options) -- find string under cursor in current working directory
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", options) -- list open buffers in current neovim instance
    keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", options) -- list available help tags
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
  end,
}
