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
      "^./.git/",
      "^./target/",
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
