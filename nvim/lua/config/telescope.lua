local telescope = require("telescope")
local actions = require("telescope.actions")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")

local function find_files(opts)
  return function()
    local fd_cmd = { "fd", "--type", "f", "--exclude", ".git", "--hidden" }
    telescope_builtin.find_files({
      find_command = fd_cmd,
      no_ignore = opts.no_ignore,
    })
  end
end

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

  if vim.g.neovide ~= nil then
    telescope.setup({
      defaults = {
        winblend = 70,
      },
    })
  end

  -- load extension to support preview of media files
  telescope.load_extension("media_files")

  -- Get fzf loaded and working with extension
  telescope.load_extension("fzf")

  telescope.load_extension("dap")

  wk.add({
    { "<leader>f", group = "Find" },

    { "<leader>ff", find_files({ no_ignore = false }), desc = "Files" },
    { "<leader>fF", find_files({ no_ignore = true }), desc = "Ignored Files" },
    { "<leader>fw", telescope_builtin.live_grep, desc = "Live grep" },
    { "<leader>fb", telescope_builtin.buffers, desc = "Buffers" },
    { "<leader>fh", telescope_builtin.help_tags, desc = "Help" },
    { "<leader>fc", telescope_builtin.commands, desc = "Commands" },
    { "<leader>fm", telescope_builtin.keymaps, desc = "Key mappings" },
    { "<leader>fi", telescope_builtin.highlights, desc = "Highlight groups" },
    { "<leader>fg", telescope_builtin.git_status, desc = "Git status" },
    { "<leader>fD", telescope_builtin.diagnostics, desc = "Workspace diagnostics" },
    { "<leader>fs", telescope_builtin.lsp_document_symbols, desc = "LSP document symbols" },
    { "<leader>fS", telescope_builtin.lsp_workspace_symbols, desc = "LSP workspace symbols" },
    { "<leader>fr", telescope_builtin.resume, desc = "Resume" },
    { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
  })
end

return M
