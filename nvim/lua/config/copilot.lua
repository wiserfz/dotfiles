local copilot = require("copilot")

local M = {}

function M.setup()
  copilot.setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      go = function()
        -- disable for go files in leetcode directory
        local cwd = vim.uv.cwd()
        if cwd ~= nil then
          if vim.fn.fnamemodify(cwd, ":t") == "leetcode" then
            return false
          end
        end
        return true
      end,
      lua = false,
      AvanteInput = false,
    },
    -- copilot_model = "gpt-41-copilot",
    should_attach = function(_, bufname)
      if not vim.bo.buflisted or not vim.opt_local.modifiable:get() or vim.bo.buftype ~= "" then
        return false
      end
      -- Protect sensitive files which often contains secrets.
      local filename = vim.fn.fnamemodify(bufname, ":t")
      for _, glob in ipairs(vim.g.llm_secret_files) do
        local regex = vim.fn.glob2regpat(glob)
        if vim.fn.match(filename, regex) ~= -1 then
          return false
        end
      end
      return true
    end,
  })
end

return M
