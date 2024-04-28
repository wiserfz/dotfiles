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

-- fancy start screen
return {
  "glepnir/dashboard-nvim",
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
  end,
}
