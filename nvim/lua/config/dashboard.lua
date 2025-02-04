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
  "    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░      ░    ",
  "               ░  ░    ░ ░        ░   ░         ░    ",
  "                                 ░                   ",
  "                                                     ",
  "                                                     ",
  "                                                     ",
  "                                                     ",
}

local dashboard = require("dashboard")

local M = {}

function M.setup()
  vim.g.dashboard_default_executive = "telescope"

  vim.cmd([[
    hi DashboardHeader guifg=#CC484D
    hi DashboardProjectTitle guifg=#CFCF9F
    hi DashboardProjectIcon guifg=#d7b0ad
    hi DashboardMruTitle guifg=#CFCF9F
    hi DashboardFiles guifg=#aec6cf
  ]])

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
end

return M
