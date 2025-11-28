local col = require("statuscol")
local builtin = require("statuscol.builtin")

local M = {}

function M.setup()
  col.setup({
    setopt = true,
    relculright = true,
    segments = {
      {
        sign = {
          namespace = { "diagnostic" },
          name = { ".*" },
          colwidth = 2,
          auto = true,
          foldclosed = true,
        },
        click = "v:lua.ScSa",
      },
      {
        text = { builtin.lnumfunc },
        click = "v:lua.ScLa",
      },
      {
        text = { " ", builtin.foldfunc, " " },
        condition = { builtin.not_empty, true, builtin.not_empty },
        click = "v:lua.ScFa",
      },
      {
        sign = {
          namespace = { "gitsigns" },
          colwidth = 1,
          wrap = true,
          foldclosed = true,
        },
        click = "v:lua.ScSa",
      },
    },
    bt_ignore = { "quickfix", "prompt", "terminal" },
    ft_ignore = {
      "sagaoutline",
      "help",
      "vim",
      "dashboard",
      "NvimTree",
      "noice",
      "lazy",
    },
  })
end

return M
