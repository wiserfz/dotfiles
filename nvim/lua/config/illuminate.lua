local illuminate = require("illuminate")

local M = {}

function M.setup()
  illuminate.configure({
    filetypes_denylist = {
      "dirbuf",
      "dirvish",
      "fugitive",
      "NvimTree",
      "dashboard",
      "help",
    },
  })

  vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "LspReferenceText" })
  vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "LspReferenceRead" })
  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "LspReferenceWrite" })
end

return M
