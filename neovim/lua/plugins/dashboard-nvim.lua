-- local default = {
--   " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
--   " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
--   " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
--   " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
--   " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
--   " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
-- }

-- local startify_ascii_header = {
--   "                                        ▟▙            ",
--   "                                        ▝▘            ",
--   "██▃▅▇█▆▖  ▗▟████▙▖   ▄████▄   ██▄  ▄██  ██  ▗▟█▆▄▄▆█▙▖",
--   "██▛▔ ▝██  ██▄▄▄▄██  ██▛▔▔▜██  ▝██  ██▘  ██  ██▛▜██▛▜██",
--   "██    ██  ██▀▀▀▀▀▘  ██▖  ▗██   ▜█▙▟█▛   ██  ██  ██  ██",
--   "██    ██  ▜█▙▄▄▄▟▊  ▀██▙▟██▀   ▝████▘   ██  ██  ██  ██",
--   "▀▀    ▀▀   ▝▀▀▀▀▀     ▀▀▀▀       ▀▀     ▀▀  ▀▀  ▀▀  ▀▀",
--   "",
-- }

local bloody = {
  "                                                     ",
  "                                                     ",
  "                                                     ",
  "                                                     ",
  "                                                     ",
  "                                                     ",
  "  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓ ",
  "  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒ ",
  " ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░ ",
  " ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██  ",
  " ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒ ",
  " ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░ ",
  " ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░ ",
  "    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░    ",
  "               ░  ░    ░ ░        ░   ░         ░    ",
  "                                 ░                   ",
  "                                                     ",
  "                                                     ",
  "                                                     ",
  "                                                     ",
}

-- fancy start screen
return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local setup, dashboard = pcall(require, "dashboard")
    if not setup then
      return
    end

    vim.g.dashboard_default_executive = "telescope"

    dashboard.setup({
      theme = "hyper",
      config = {
        header = bloody,
        shortcut = {
          {
            icon = " ",
            desc = "Lazy Manager",
            action = "Lazy",
            key = "L",
          },
          {
            icon = " ",
            desc = "Mason Manager",
            group = "@property",
            action = "Mason",
            key = "M",
          },
          {
            icon = " ",
            desc = "Dotfiles project",
            group = "Number",
            action = ":e ~/workspace/dotfiles/",
            key = ".",
          },
          {
            icon = "󰈆 ",
            desc = "Quit Neovim",
            group = "DiagnosticError",
            action = "qa",
            key = "q",
          },
        },
        project = {
          -- enable = false,
          limit = 5,
          action = "Telescope find_files hidden=true cwd=",
        },
        mru = {
          limit = 5,
        },
      },
    })
  end,
}
