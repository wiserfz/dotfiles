local col = require("statuscol")
local builtin = require("statuscol.builtin")

local M = {}

function M.setup()
  col.setup({
    setopt = true,
    relculright = true,
    segments = {
      {
        text = { " ", builtin.foldfunc, " " },
        condition = { builtin.not_empty, true, builtin.not_empty },
        click = "v:lua.ScFa",
      },
      {
        sign = {
          namespace = { "diagnostic" },
          maxwidth = 1,
          colwidth = 2,
          auto = true,
          foldclosed = true,
        },
        click = "v:lua.ScSa",
      },
      {
        sign = {
          name = { ".*" },
          text = { ".*" },
          maxwidth = 2,
          colwidth = 2,
          auto = true,
          foldclosed = true,
        },
        click = "v:lua.ScSa",
      },
      { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
      {
        sign = {
          namespace = { "gitsigns" },
          maxwidth = 2,
          colwidth = 1,
          wrap = true,
          foldclosed = true,
        },
        click = "v:lua.ScSa",
      },
    },
    ft_ignore = {
      -- "sagaoutline",
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
