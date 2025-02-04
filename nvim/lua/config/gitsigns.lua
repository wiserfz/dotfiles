local gitsigns = require("gitsigns")
local util = require("util")

local M = {}

function M.setup()
  gitsigns.setup({
    on_attach = function(bufnr)
      local opts = { buffer = bufnr }

      -- Navigation
      util.map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, opts)

      util.map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, opts)

      -- Actions
      util.map("n", "<leader>hs", gitsigns.stage_hunk, opts)
      util.map("n", "<leader>hr", gitsigns.reset_hunk, opts)
      util.map("v", "<leader>hs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, opts)
      util.map("v", "<leader>hr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, opts)
      util.map("n", "<leader>hS", gitsigns.stage_buffer, opts)
      util.map("n", "<leader>hu", gitsigns.undo_stage_hunk, opts)
      util.map("n", "<leader>hR", gitsigns.reset_buffer, opts)
      util.map("n", "<leader>hp", gitsigns.preview_hunk, opts)
      util.map("n", "<leader>hb", function()
        gitsigns.blame_line({ full = true })
      end, opts)
      util.map("n", "<leader>tb", gitsigns.toggle_current_line_blame, opts)
      util.map("n", "<leader>hd", gitsigns.diffthis, opts)
      util.map("n", "<leader>hD", function()
        gitsigns.diffthis("~")
      end, opts)
      util.map("n", "<leader>td", gitsigns.toggle_deleted, opts)

      -- Text object
      util.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", opts)
    end,
  })
end

return M
