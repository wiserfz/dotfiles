local status, todo = pcall(require, "todo-comments")

if not status then
  return
end

local map = vim.keymap

map.set("n", "<leader>]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

map.set("n", "<leader>[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

todo.setup({
  colors = {
    error = { "DiagnosticError", "ErrorMsg", "#de5d68" },
    warning = { "DiagnosticWarning", "WarningMsg", "#eeb927" },
    info = { "DiagnosticInfo", "#57a5e5" },
    hint = { "DiagnosticHint", "#bb70d2" },
    default = { "Identifier", "#de5d68" },
  },
})
