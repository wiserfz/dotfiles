local noice = require("noice")
local wk = require("which-key")
local notify = require("notify")

local function create_skip_filter(pattern)
  return {
    filter = { find = pattern },
    opts = { skip = true },
  }
end

local disabled_message_pattern = {
  "^[/?].*%[%d+/%d+%]", -- Searching up/down
  "E486: Pattern not found:", -- Searcing not found
  "%d+ changes?;", -- Undoing/redoing
  "%d+ fewer lines", -- Deleting multiple lines
  "%d+ more lines", -- Undoing deletion of multiple lines
  "%d+ lines ", -- Performing some other verb on multiple lines
  "Already at newest change", -- Redoing
  '"[^"]+" %d+L, %d+B', -- Saving
  "^Hunk %d+ of %d+", -- Git hunk messages
  "Content is not an image.", -- Image clip warning
}

local disable_notfiy_info_pattern = {
  "^Opening .*://.*", -- URL opening messages
  "Invalid server name '.*'", -- Invalid server name
  "^No matching notification found to replace$", -- vim-notify plugin
  "^No information available$", -- LSP hover result with no information
}

local filter_message_routes = vim.tbl_map(create_skip_filter, disabled_message_pattern)
local filter_notify_info_routes = vim.tbl_map(create_skip_filter, disable_notfiy_info_pattern)
local other_routes = function(event)
  if event == "notify" then
    return {
      { view = "notify", filter = { event = event, kind = "info" } },
    }
  else
    -- always route any messages with more than 20 lines to the split view
    return {
      { view = "split", filter = { event = event, min_height = 20 } },
    }
  end
end

local M = {}

function M.setup()
  notify.setup({
    on_open = function(win)
      if vim.g.neovide ~= nil then
        vim.wo[win].winblend = 100
      end
    end,
  })

  noice.setup({
    cmdline = {
      format = {
        cmdline = {
          pattern = "^:",
          icon = "",
          lang = "vim",
          opts = {
            buf_options = { filetype = "NoiceCommandline" },
          },
        },
        search_up = { kind = "search", pattern = "^%?", icon = " 󰜷", lang = "regex" },
        search_down = { kind = "search", pattern = "^/", icon = " 󰜮", lang = "regex" },
      },
    },
    routes = vim.list_extend(
      vim.list_extend(filter_message_routes, other_routes("msg_show")),
      vim.list_extend(filter_notify_info_routes, other_routes("notify"))
    ),
    lsp = {
      progress = {
        enabled = false,
      },
      hover = {
        -- Disable "no information available" popup which is really annoying
        -- when using multiple servers
        silent = true,
      },
    },
    presets = {
      lsp_doc_border = true,
    },
    views = {
      cmdline_popup = {
        win_options = {
          winblend = 100,
        },
      },
    },
  })

  wk.add({
    noremap = false,
    silent = true,

    { "<leader>n", group = "Noice" },

    {
      "<leader>nl",
      function()
        noice.cmd("last")
      end,
      desc = "Last message",
    },
    {
      "<leader>ns",
      function()
        noice.cmd("history")
      end,
      desc = "Message history",
    },
  })
end

return M
