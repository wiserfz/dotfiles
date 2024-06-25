return {
  "sontungexpt/url-open",
  event = "VeryLazy",
  cmd = "URLOpenUnderCursor",
  opts = {
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
  },
  keys = {
    { "<leader>gx", "<cmd>URLOpenUnderCursor<CR>", mode = "n", noremap = false, silent = true },
  },
  config = function(_, opts)
    local status_ok, url_open = pcall(require, "url-open")
    if not status_ok then
      return
    end
    url_open.setup(opts)
  end,
}
