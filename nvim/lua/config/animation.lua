local animate = require("mini.animate")

local M = {}

function M.setup()
  animate.setup({
    cursor = {
      enable = true,
      timing = function(_, n)
        return math.min(10, 250 / n)
      end,
      path = animate.gen_path.line({
        predicate = function()
          return true
        end,
      }),
    },
    scroll = { enable = false },
  })
end

return M
