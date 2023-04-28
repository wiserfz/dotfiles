-- keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- clear search highlights
map("n", "<leader>nh", ":nohl<CR>")

-- window management
map("n", "<leader>|", "<C-w>v") -- split window vertically
map("n", "<leader>-", "<C-w>s") -- split window horizontally
map("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
map("n", "<leader>sx", ":close<CR>") -- close current split window

map("n", "<leader>to", ":tabnew<CR>") -- open new tab
map("n", "<leader>tx", ":tabclose<CR>") -- close current tab
map("n", "<leader>tn", ":tabn<CR>") --  go to next tab
map("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

-- Toggle nvim-tree
map("n", "<leader>fe", ":NvimTreeToggle<CR>") -- toggle file explorer
-- plugin key maps
map("n", "<leader>sz", ":MaximizerToggle<CR>") -- toggle split window maximization
map("n", "<leader>szz", ":MaximizerToggle!<CR>") -- toggle split window maximization

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>") -- find files within current working directory, respects .gitignore
map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- bufferline
map("n", "]b", "<cmd>BufferLineCycleNext<cr>") -- move to next tab buffer
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>") -- move to previous tab buffer

-- debugging with DAP
map("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>")
map("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>")
map("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>")
map("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>")
map("n", "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
map(
  "n",
  "<leader>B",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Conditional Breakpoint" }
)
map(
  "n",
  "<leader>lp",
  "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
  { desc = "Log Breakpoint" }
)
map("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "REPL" })
map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run Last Config" })

map("n", "<leader>dT", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate" })
map(
  "n",
  "<leader>dD",
  "<cmd>lua require'dap'.disconnect()<CR> require'dap'.close()<CR>",
  { desc = "Disconnect & Close" }
)

map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle debug UI" })
map("n", "<leader>de", "<cmd>lua require'dapui'.eval()<CR>", { desc = "Evaluate under cursor" })

-- leetcode
map("n", "<leader>ll", "<cmd>LeetCodeList<CR>")
map("n", "<leader>lt", "<cmd>LeetCodeTest<CR>")
map("n", "<leader>ls", "<cmd>LeetCodeSubmit<CR>")
map("n", "<leader>li", "<cmd>LeetCodeSignIn<CR>")
