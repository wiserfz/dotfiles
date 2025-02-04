local telescope = require("telescope")
local actions = require("telescope.actions")
local util = require("util")

local M = {}

function M.setup()
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
      layout_config = {
        vertical = {
          width = 0.5,
        },
      },
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

  util.map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>") -- find files within current working directory, respects .gitignore
  util.map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
  util.map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
  util.map("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
  util.map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
  util.map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
end

return M
