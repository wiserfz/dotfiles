local gitsigns = require("gitsigns")
local wk = require("which-key")

local M = {}

function M.setup()
  gitsigns.setup({
    on_attach = function(bufnr)
      local opts = { buffer = bufnr }

      wk.add({
        buffer = bufnr,
        noremap = false,
        silent = true,

        { "<leader>h", group = "Git" },

        {
          "<leader>hk",
          function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end,
          desc = "Previous hunk",
        },
        {
          "<leader>hj",
          function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end,
          desc = "Next hunk",
        },
        { "<leader>hs", gitsigns.stage_hunk, desc = "Stage hunk" },
        { "<leader>hr", gitsigns.reset_hunk, desc = "Reset hunk" },
        {
          "<leader>hs",
          function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end,
          mode = "v",
          desc = "Stage select hunk",
        },
        {
          "<leader>hr",
          function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end,
          mode = "v",
          desc = "Reset select hunk",
        },
        { "<leader>hS", gitsigns.stage_buffer, desc = "Stage buffer" },
        { "<leader>hR", gitsigns.reset_buffer, desc = "Reset buffer" },
        { "<leader>hp", gitsigns.preview_hunk, desc = "Preview hunk" },
        {
          "<leader>hB",
          function()
            gitsigns.blame_line({ full = true })
          end,
          desc = "Toggle buffer blame line",
        },
        {
          "<leader>hb",
          gitsigns.toggle_current_line_blame,
          desc = "Toggle blame line of current line",
        },
        { "<leader>hd", gitsigns.diffthis, desc = "Diff in hunk preview" },
        {
          "<leader>hD",
          function()
            gitsigns.diffthis("~")
          end,
          desc = "Diff in buffer",
        },
      })
    end,
  })
end

return M
