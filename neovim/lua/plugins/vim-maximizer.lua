-- maximizes and restores current window
return {
  "szw/vim-maximizer",
  keys = {
    { "<leader>sz", "<cmd>MaximizerToggle<CR>" }, -- toggle split window maximization
    { "<leader>szz", "<cmd>MaximizerToggle!<CR>" }, -- toggle split window maximization
  },
}
