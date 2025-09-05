local visual_whitespace = require("visual-whitespace")

local M = {}

function M.setup()
  visual_whitespace.setup({
    enable = true,
    highlight = { link = "Comment" },
    match_types = {
      space = false,
      tab = true,
      nbsp = true,
      lead = true,
      trail = true,
    },
    list_chars = {
      space = "·",
      tab = "» ",
      nbsp = "␣",
      lead = "·",
      trail = "·",
    },
    fileformat_chars = {
      unix = "¬",
    },
  })
end

return M
