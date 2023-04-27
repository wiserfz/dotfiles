-- plugin of dashboard-nvim
local M = {}

-- local default = {
--   " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
--   " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
--   " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
--   " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
--   " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
--   " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
-- }

local bloody = {
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

function M.setup()
  vim.g.dashboard_default_executive = "telescope"
  local dashboard = require("dashboard")
  dashboard.setup({
    theme = "hyper",
    config = {
      header = bloody,
      shortcut = {
        {
          icon = "  ",
          desc = "Update Packer Plugins",
          action = "PackerUpdate",
          key = "U",
        },
        {
          icon = " ",
          desc = "Display Mason Info",
          group = "@property",
          action = "Mason",
          key = "M",
        },
        {
          icon = " ",
          desc = "Edit nvim settings",
          group = "Number",
          action = ":e ~/workspace/dotfiles/",
          key = ".",
        },
        {
          icon = " ",
          desc = "Quit Neovim",
          group = "DiagnosticError",
          action = "qa",
          key = "q",
        },
      },
      project = { limit = 5, action = "Telescope find_files hidden=true cwd=" },
      mru = { limit = 10 },
    },
  })
end

return M
