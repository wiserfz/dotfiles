local autopairs = require("nvim-autopairs")

local M = {}

function M.setup()
  -- configure autopairs
  autopairs.setup({
    disable_in_macro = false,
    enable_check_bracket_line = false, -- Don't add pairs if it already has a close pair in the same line
    ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    check_ts = true, -- enable treesitter
    ts_config = {
      lua = { "string" }, -- don't add pairs in lua string treesitter nodes
    },
  })

  local Rule = require("nvim-autopairs.rule")
  local cond = require("nvim-autopairs.conds")

  autopairs.add_rules({
    Rule("<", ">", "rust"):with_pair(cond.before_regex("%a+")):with_move(function(opts)
      return opts.char == ">"
    end),
  })
end

return M
