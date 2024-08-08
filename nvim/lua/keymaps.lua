local M = {}

local util = require("util")
local wk = require("which-key")

function M.setup()
  wk.add({
    noremap = false,
    silent = true,

    { "<leader>nh", "<cmd>nohl<cr>", desc = "No highlights" },
    { "<leader>|", "<C-w>v", desc = "Split window vertically" },
    { "<leader>-", "<C-w>s", desc = "Split window horizontally" },

    { "<leader>s", group = "Window" },
    { "<leader>se", "<C-w>=", desc = "Equal split window" },
    { "<leader>sx", "<cmd>close<cr>", desc = "Close current window" },
    { "<leader>sz", "<cmd>MaximizerToggle<cr>", desc = "Maximize current window" },
    { "<leader>s!", "<cmd>MaximizerToggle!<cr>", desc = "Restore all windows" },

    { "<leader>t", group = "Tab" },
    { "<leader>to", "<cmd>tabnew<cr>", desc = "New tab" },
    { "<leader>tx", "<cmd>tabclose<cr>", desc = "Close tab" },
    { "<leader>tn", "<cmd>tabn<cr>", desc = "Next tab" },
    { "<leader>tp", "<cmd>tabp<cr>", desc = "Previous tab" },
  })
end

return M
