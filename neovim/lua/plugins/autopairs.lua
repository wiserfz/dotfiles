-- import nvim-autopairs safely
local autopairs_setup, autopairs = pcall(require, "nvim-autopairs")
if not autopairs_setup then
  return
end

-- configure autopairs
autopairs.setup({
  enable_check_bracket_line = false, -- Don't add pairs if it already has a close pair in the same line
  ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
  check_ts = true, -- enable treesitter
  ts_config = {
    lua = { "string" }, -- don't add pairs in lua string treesitter nodes
    javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
    java = false, -- don't check treesitter on java
  },
  -- disable_filetype = { "TelescopePrompt", "spectre_panel" },
  -- fast_wrap = {
  --   map = "<M-e>",
  --   chars = { "{", "[", "(", '"', "'" },
  --   pattern = [=[[%'%"%>%]%)%}%,]]=],
  --   offset = 0, -- Offset from pattern match
  --   end_key = "$",
  --   keys = "qwertyuiopzxcvbnmasdfghjkl",
  --   check_comma = true,
  --   highlight = "Search",
  --   highlight_grey = "Comment",
  -- },
})

local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

autopairs.add_rules({
  Rule("<", ">", "rust"):with_pair(cond.before_regex("%a+")):with_move(function(opts)
    return opts.char == ">"
  end),
})

-- import nvim-autopairs completion functionality safely
local cmp_autopairs_setup, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
if not cmp_autopairs_setup then
  return
end

-- import nvim-cmp plugin safely (completions plugin)
local cmp_setup, cmp = pcall(require, "cmp")
if not cmp_setup then
  return
end

-- make autopairs and completion work together
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
