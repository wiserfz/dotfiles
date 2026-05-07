local M = {}

local util = require("util")
local wk = require("which-key")

local patterns = {
  {
    pattern = "^[\"']?([^%s~/]+/[^%s~/]+)[\"']?$",
    prefix = "https://github.com/",
    ft = { "lua" },
  },
}

-- NOTE: COPY from https://github.com/neovim/neovim/blob/832a68835b741bf874b936f933d662a5e1159e32/runtime/lua/vim/_core/defaults.lua#L149-L163
local function do_open(uri)
  local cmd, err = vim.ui.open(uri)
  local rv = cmd and cmd:wait(1000) or nil
  if cmd and rv and rv.code ~= 0 then
    err = ("vim.ui.open: command %s (%d): %s"):format(
      (rv.code == 124 and "timeout" or "failed"),
      rv.code,
      vim.inspect(cmd.cmd)
    )
  end
  return err
end

local gx_desc =
  "Opens filepath or URI under cursor with the system handler (file explorer, web browser, …)"

function M.setup()
  wk.add({
    noremap = false,
    silent = true,

    { "<leader>nh", "<cmd>nohl<cr>", desc = "No highlights" },
    { "<leader>|", "<C-w>v", desc = "Split window vertically" },
    { "<leader>-", "<C-w>s", desc = "Split window horizontally" },

    { "<leader>s", group = "Window" },
    { "<leader>se", "<C-w>=", desc = "Equal split window" },
    { "<leader>sx", "<cmd>close<cr>", desc = "Close current window" },
    { "<leader>sz", "<cmd>MaximizerToggle<cr>", desc = "Maximize current window" },
    { "<leader>s!", "<cmd>MaximizerToggle!<cr>", desc = "Restore all windows" },

    { "<leader>t", group = "Tab" },
    { "<leader>to", "<cmd>tabnew<cr>", desc = "New tab" },
    { "<leader>tx", "<cmd>tabclose<cr>", desc = "Close tab" },
    { "<leader>tn", "<cmd>tabn<cr>", desc = "Next tab" },
    { "<leader>tp", "<cmd>tabp<cr>", desc = "Previous tab" },

    {
      "gx",
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

        for _, url in ipairs(require("vim.ui")._get_urls()) do
          for _, cond in ipairs(patterns) do
            if vim.tbl_contains(cond.ft, ft) and url:match(cond.pattern) ~= nil then
              url = (cond.prefix or "") .. url
              break
            end
          end

          local err = do_open(url)
          if err then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = gx_desc,
    },
  })
end

return M
