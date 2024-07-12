return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local status, todo = pcall(require, "todo-comments")
    if not status then
      return
    end

    todo.setup({
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#de5d68" },
        warning = { "DiagnosticWarning", "WarningMsg", "#eeb927" },
        info = { "DiagnosticInfo", "#57a5e5" },
        hint = { "DiagnosticHint", "#bb70d2" },
        default = { "Identifier", "#de5d68" },
      },
    })

    local keymap = vim.keymap
    keymap.set("n", "<leader>]t", function()
      todo.jump_next()
    end, { desc = "Next todo comment" })

    keymap.set("n", "<leader>[t", function()
      todo.jump_prev()
    end, { desc = "Previous todo comment" })
  end,
}
