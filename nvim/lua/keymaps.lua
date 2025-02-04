local M = {}

local util = require("util")

function M.setup()
  -- clear search highlights
  util.map("n", "<leader>nh", ":nohl<CR>")

  -- window management
  util.map("n", "<leader>|", "<C-w>v") -- split window vertically
  util.map("n", "<leader>-", "<C-w>s") -- split window horizontally
  util.map("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
  util.map("n", "<leader>sx", ":close<CR>") -- close current split window

  util.map("n", "<leader>to", ":tabnew<CR>") -- open new tab
  util.map("n", "<leader>tx", ":tabclose<CR>") -- close current tab
  util.map("n", "<leader>tn", ":tabn<CR>") --  go to next tab
  util.map("n", "<leader>tp", ":tabp<CR>") --  go to previous tab
end

return M
