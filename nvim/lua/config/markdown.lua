local md = require("render-markdown")
local wk = require("which-key")

local M = {}

local opts = {
  enabled = false,
  file_types = { "markdown" },
  render_modes = { "n", "c" },
  anti_conceal = { enabled = false },
  checkbox = {
    enabled = true,
    unchecked = { icon = "✘ ", highlight = "RenderMarkdownUnchecked" },
    checked = { icon = "✔ ", highlight = "RenderMarkdownChecked" },
    custom = {
      todo = { raw = "[-]", rendered = "◯ ", highlight = "RenderMarkdownTodo" },
    },
  },
  code = {
    enabled = true,
    sign = false,
    style = "full",
    highlight = "RenderMarkdownCode",
    highlight_inline = "RenderMarkdownCodeInline",
  },
  dash = {
    enabled = true,
  },
  heading = {
    enabled = true,
    sign = false,
    icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
    backgrounds = {
      "RenderMarkdownH1Bg",
      "RenderMarkdownH2Bg",
      "RenderMarkdownH3Bg",
      "RenderMarkdownH4Bg",
      "RenderMarkdownH5Bg",
      "RenderMarkdownH6Bg",
    },
    foregrounds = {
      "RenderMarkdownH1",
      "RenderMarkdownH2",
      "RenderMarkdownH3",
      "RenderMarkdownH4",
      "RenderMarkdownH5",
      "RenderMarkdownH6",
    },
  },
  latex = {
    enabled = true,
    highlight = "RenderMarkdownMath",
  },
  link = {
    enabled = true,
    image = "󰥶 ",
    hyperlink = "󰌹 ",
    highlight = "RenderMarkdownLink",
    custom = {
      web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
      python = { pattern = "%.py$", icon = "󰌠 ", highlight = "RenderMarkdownLink" },
      rust = { pattern = "%.rs$", icon = "󱘗 ", highlight = "RenderMarkdownLink" },
      go = { pattern = "%.go$", icon = " ", highlight = "RenderMarkdownLink" },
      erlang = { pattern = "%.erl$", icon = " ", highlight = "RenderMarkdownLink" },
    },
  },
  bullet = {
    enabled = true,
    icons = { "●", "○", "◆", "◇" },
    highlight = "RenderMarkdownBullet",
  },
  sign = { enabled = false },
  pipe_table = {
    enabled = true,
    preset = "round",
    style = "full",
    head = "RenderMarkdownTableHead",
    row = "RenderMarkdownTableRow",
    filler = "RenderMarkdownTableFill",
  },
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
