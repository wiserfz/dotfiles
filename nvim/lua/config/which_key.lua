local wk = require("which-key")

local M = {}

function M.setup()
  vim.opt.timeoutlen = 1000

  wk.setup({
    preset = "modern",
    delay = 1000,
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
      ellipsis = "…",
      rules = {
        -- plugins
        { plugin = "telescope.nvim", pattern = "telescope", icon = "", color = "blue" },
        { plugin = "todo-comments.nvim", pattern = "todo", icon = " ", hl = "DevIconMjs" },
        { plugin = "lazy.nvim", cat = "filetype", name = "lazy" },
        { plugin = "lspsaga.nvim", pattern = "lsp", icon = " ", hl = "Type" },
        { plugin = "codecompanion.nvim", pattern = "ai", icon = " ", hl = "Macro" },
        -- { pattern = "lazy", icon = "󰒲 ", color = "purple" },
        { pattern = "tmux", icon = " ", color = "blue" },

        -- window
        { pattern = "maximize", icon = " ", hl = "DevIconWindows" },
        { pattern = "restore", icon = " ", hl = "DevIconWindows" },
        { pattern = "split window vertically", icon = " ", hl = "DevIconWindows" },
        { pattern = "split window horizontally", icon = " ", hl = "DevIconWindows" },
        { pattern = "window", icon = " ", hl = "DevIconWindows" },

        -- buffer
        { pattern = "buffer", icon = "󰈔", color = "cyan" },

        -- crates
        { plugin = "crates.nvim", pattern = "crates", icon = "󱘗 ", hl = "DiagnosticSignWarn" },
        { pattern = "expand to inline table", icon = "󰅪 ", hl = "DiagnosticSignWarn" },
        { pattern = "extract into table", icon = "󰅪 ", hl = "DiagnosticSignWarn" },

        -- format
        { pattern = "format", icon = "󰁨  ", hl = "DevIconGitIgnore" },

        -- action
        { pattern = "open", icon = " ", hl = "DevIconZshrc" },
        { pattern = "close", icon = "󰅙 ", hl = "DevIconHurl" },
        { pattern = "toggle", icon = " ", color = "yellow" },
        { pattern = "reload", icon = "󰑓 ", color = "yellow" },
        { pattern = "update", icon = " ", color = "cyan" },
        { pattern = "upgrade", icon = " ", hl = "Function" },
        { pattern = "diagnostic", icon = "󱖫 ", color = "red" },
        { pattern = "list", icon = " ", hl = "DevIconHexadecimal" },
        { pattern = "exit", icon = "󰈆 ", color = "red" },
        { pattern = "quit", icon = "󰈆 ", color = "red" },
        { pattern = "action", icon = " ", hl = "Function" },
        { pattern = "reset", icon = "󰑛 ", hl = "Function" },
        { pattern = "change", icon = " ", hl = "Function" },
        { pattern = "delete", icon = "󰆴 ", hl = "Function" },
        { pattern = "yank", icon = " ", color = "orange" },
        { pattern = "replace", icon = " ", color = "orange" },
        { pattern = "run", icon = " ", hl = "Function" },
        { pattern = "add", icon = " ", hl = "DiffAdd" },

        -- { pattern = "dashboard", icon = " ", hl = "DevIconVim" },
        { pattern = "file explorer", icon = " ", hl = "Directory" },
        { pattern = "line", icon = " ", color = "green" },
        { pattern = "git", icon = "󰊢 ", color = "orange" },
        { pattern = "mason", icon = "󱌢 ", color = "purple" },
        { pattern = "surround", icon = "󰅲 ", color = "green" },
        { pattern = "ufo", icon = " ", color = "yellow" },
        { pattern = "tab", icon = "󰓩 ", color = "purple" },
        { pattern = "which-key", icon = " ", color = "azure" },
        { pattern = "terminal", icon = "  ", color = "red" },
        { pattern = "find", icon = "󰈞 ", hl = "Function" },
        { pattern = "search", icon = " ", hl = "Function" },
        { pattern = "debug", icon = "󰃤 ", color = "red" },
        { pattern = "code", icon = " ", color = "orange" },
        { pattern = "notif", icon = "󰵅 ", color = "blue" },
        { pattern = "session", icon = " ", color = "azure" },
        { pattern = "ui", icon = "󰙵 ", color = "cyan" },
        { pattern = "incoming", icon = "󰏷 ", hl = "Function" },
        { pattern = "outgoing", icon = "󰏻 ", hl = "Function" },
        { pattern = "diff", icon = " ", color = "red" },
        { pattern = "save", icon = " ", color = "blue" },
        { pattern = "treesitter", icon = " ", color = "green" },
        { pattern = "render markdown", icon = " ", color = "purple" },
        { pattern = "blame", icon = "󱜸 ", color = "red" },
        { pattern = "project", icon = " ", color = "yellow" },
        { pattern = "undo", icon = "󰕍 ", hl = "Type" },
        { pattern = "rename", icon = "󰑕  ", hl = "Identifier" },
        { pattern = "trim", icon = "󰁨 ", color = "red" },
        { pattern = "fix", icon = "󰁨 ", color = "cyan" },
        { pattern = "info", icon = " ", hl = "Type" },
        { pattern = "branch", icon = "󰳏 ", color = "yellow" },
        { pattern = "symbol", icon = " ", color = "cyan" },
        { pattern = "preview", icon = " ", hl = "Type" },
        { pattern = "help", icon = "󰘥 ", hl = "DevIconDoc" },
        { pattern = "click", icon = "󰳽 ", hl = "Normal" },
        { pattern = "hover", icon = " ", hl = "Normal" },
        { pattern = "prev", icon = "󰳡 ", hl = "Type" },
        { pattern = "next", icon = "󰳛 ", hl = "Type" },
        { pattern = "up", icon = "󰜷 ", hl = "Type" },
        { pattern = "down", icon = "󰜮 ", hl = "Type" },
        { pattern = "left", icon = "󰜱 ", hl = "Type" },
        { pattern = "right", icon = "󰜴 ", hl = "Type" },
      },
    },
  })

  wk.add({
    { "<leader>k", "<cmd>WhichKey<cr>", desc = "Which-key?" },
    {
      "<leader>?",
      function()
        wk.show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  })
end

return M
