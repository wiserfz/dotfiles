local url = require("url-open")
local wk = require("which-key")

local M = {}

local options = {

  -- default will open url with default browser of your system or you can choose your browser like this
  -- open_app = "micorsoft-edge-stable",
  -- google-chrome, firefox, micorsoft-edge-stable, opera, brave, vivaldi
  open_app = "default",
  -- If true, only open the URL when the cursor is in the middle of the URL.
  -- If false, open the next URL found from the cursor position,
  -- which means you can open a URL even when the cursor is in front of the URL or in the middle of the URL.
  open_only_when_cursor_on_url = true,
  highlight_url = {
    all_urls = {
      enabled = false,
      fg = "#cd9d4e", -- "text" or "#rrggbb"
      -- fg = "text", -- text will set underline same color with text
      bg = nil, -- nil or "#rrggbb"
      underline = false,
    },
    cursor_move = {
      enabled = true,
      fg = "#5A8DD5", -- "text" or "#rrggbb"
      -- fg = "text", -- text will set underline same color with text
      bg = nil, -- nil or "#rrggbb"
      underline = true,
    },
  },
}

function M.setup()
  url.setup(options)

  wk.add({
    { "<leader>g", group = "Url" },

    {
      "<leader>gx",
      "<cmd>URLOpenUnderCursor<cr>",
      desc = "Url open",
      noremap = false,
      silent = true,
    },
  })
end

return M
