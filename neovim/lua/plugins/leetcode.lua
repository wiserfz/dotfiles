local leet_arg = "leetcode.nvim"

return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- required by telescope
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = leet_arg ~= vim.fn.argv()[1],
  opts = {
    lang = "golang",
    cn = { -- leetcode.cn
      enabled = true,
    },
    storage = {
      home = os.getenv("HOME") .. "/workspace/leetcode",
    },
    arg = leet_arg,
  },
  keys = {
    { "<leader>ll", "<cmd>Leet list<CR>", mode = "n", noremap = false, silent = true }, -- open problem list
    { "<leader>lr", "<cmd>Leet run<CR>", mode = "n", noremap = false, silent = true }, -- run currently opened question
    { "<leader>ls", "<cmd>Leet submit<CR>", mode = "n", noremap = false, silent = true }, -- submit currently opened question
    { "<leader>lo", "<cmd>Leet open<CR>", mode = "n", noremap = false, silent = true }, -- opens the current question in a default browser
    { "<leader>lcu", "<cmd>Leet cookie update<CR>", mode = "n", noremap = false, silent = true }, -- opens a prompt to enter a new cookie
  },
}
