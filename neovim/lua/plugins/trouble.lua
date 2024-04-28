-- trouble highlight, show in a sigle panel lsp error and warnings
return {
  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Open/close trouble list" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Open trouble workspace diagnostics" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Open trouble document diagnostics" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", desc = "Open trouble quickfix list" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "Open trouble location list" },
    { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
  },
  config = function()
    local status, trouble = pcall(require, "trouble")

    if not status then
      return
    end

    trouble.setup({
      position = "right",
      width = 75,
      padding = true,
      auto_preview = false,
    })
  end,
}
