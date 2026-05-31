local md = require("render-markdown")
local wk = require("which-key")

local M = {}

---@module "render-markdown"
---@type render.md.UserConfig
local opts = {
  enabled = false,
  file_types = { "markdown", "codecompanion", "Avante" },
  anti_conceal = { enabled = false },
  checkbox = {
    unchecked = { icon = "✘ " },
    checked = { icon = "✔ " },
    custom = {
      todo = { raw = "[-]", rendered = "◯ " },
    },
  },
  code = { sign = false },
  completions = { lsp = { enabled = true } },
  heading = {
    sign = false,
    icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
  },
  link = {
    custom = {
      python = { pattern = "%.py$", icon = "󰌠 " },
      rust = { pattern = "%.rs$", icon = "󱘗 " },
      go = { pattern = "%.go$", icon = " " },
      erlang = { pattern = "%.erl$", icon = " " },
    },
  },
  sign = { enabled = false },
  pipe_table = { preset = "round" },
}

function M.setup()
  md.setup(opts)

  wk.add({
    { "<leader>m", group = "Markdown" },

    {
      "<leader>mv",
      "<cmd>RenderMarkdown toggle<cr>",
      desc = "Render Markdown",
      noremap = false,
      silent = true,
    },
  })
end

return M
