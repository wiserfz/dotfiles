local col = require("statuscol")
local builtin = require("statuscol.builtin")

local M = {}

function M.setup()
  col.setup({
    relculright = true,
    segments = {
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
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
      { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
      {
        sign = {
          namespace = { "gitsigns" },
          maxwidth = 1,
          colwidth = 1,
          wrap = true,
          foldclosed = true,
        },
        click = "v:lua.ScSa",
      },
    },
  })
end

return M
