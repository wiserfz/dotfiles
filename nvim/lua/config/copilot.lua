local copilot = require("copilot")

local M = {}

function M.setup()
  copilot.setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      go = function()
        -- disable for go files in leetcode directory
        if
          string.match(vim.fs.basename(vim.fs.dirname(vim.api.nvim_buf_get_name(0))), "^leetcode$")
        then
          return false
        end
        return true
      end,
    },
  })
end

return M
