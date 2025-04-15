local leetcode = require("leetcode")
local wk = require("which-key")

local M = {}

function M.setup()
  leetcode.setup({
    arg = "leetcode.nvim",
    lang = "golang",
    cn = { -- leetcode.cn
      enabled = true,
    },
    storage = {
      home = os.getenv("HOME") .. "/Workspace/leetcode",
    },
    logging = false,
    injector = {
      ["golang"] = {
        before = {
          "package main",
        },
        after = {
          "func main() {",
          "\t// your code here",
          "}",
        },
      },
    },
    cache = { update_interval = 60 * 60 * 24 },
    picker = {
      provider = "telescope",
    },
  })

  wk.add({
    noremap = false,
    silent = true,

    { "<leader>l", group = "Leetcode" },

    { "<leader>ll", "<cmd>Leet list<cr>", desc = "Problem list" },
    { "<leader>lr", "<cmd>Leet run<cr>", desc = "Run current solution" },
    { "<leader>ls", "<cmd>Leet submit<cr>", desc = "Subimt current solution" },
    { "<leader>lo", "<cmd>Leet open<cr>", desc = "Open current problem" },
    { "<leader>lc", "<cmd>Leet console<cr>", desc = "Open console for current problem" },
    {
      "<leader>lu",
      "<cmd>Leet cookie update<CR>",
      desc = "Update cookie",
    },
  })
end

return M
