return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lang = "golang",
      cn = { -- leetcode.cn
        enabled = true,
      },
      storage = {
        home = os.getenv("HOME") .. "/workspace/my-go",
      },
    },
    config = function(_, opts)
      local keymap = vim.keymap
      local options = { noremap = false, silent = true }

      keymap.set("n", "<leader>ll", "<cmd>Leet list<CR>", options) -- open problem list
      keymap.set("n", "<leader>lr", "<cmd>Leet run<CR>", options) -- run currently opened question
      keymap.set("n", "<leader>ls", "<cmd>Leet submit<CR>", options) -- submit currently opened question
      keymap.set("n", "<leader>la", "<cmd>Leet last_submit<CR>", options) -- retrieve last submitted code for the current question
      keymap.set("n", "<leader>lo", "<cmd>Leet open<CR>", options) -- opens the current question in a default browser
      keymap.set("n", "<leader>lcu", "<cmd>Leet cookie update<CR>", options) -- opens a prompt to enter a new cookie

      require("leetcode").setup(opts)
    end,
  },
}
