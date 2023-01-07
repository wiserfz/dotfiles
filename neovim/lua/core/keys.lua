-- keymaps
local map = vim.api.nvim_set_keymap

-- clear search highlights
map("n", "<leader>nh", ":nohl<CR>", {})

-- window management
map("n", "<leader>sv", "<C-w>v", {}) -- split window vertically
map("n", "<leader>sh", "<C-w>s", {}) -- split window horizontally
map("n", "<leader>se", "<C-w>=", {}) -- make split windows equal width & height
map("n", "<leader>sx", ":close<CR>", {}) -- close current split window

map("n", "<leader>to", ":tabnew<CR>", {}) -- open new tab
map("n", "<leader>tx", ":tabclose<CR>", {}) -- close current tab
map("n", "<leader>tn", ":tabn<CR>", {}) --  go to next tab
map("n", "<leader>tp", ":tabp<CR>", {}) --  go to previous tab

-- Toggle nvim-tree
map("n", "<leader>ft", ":NvimTreeToggle<CR>", {}) -- toggle file explorer
-- plugin key maps
map("n", "<leader>sz", ":MaximizerToggle<CR>", {}) -- toggle split window maximization

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {}) -- find files within current working directory, respects .gitignore
map("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", {}) -- find string in current working directory as you type
map("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", {}) -- find string under cursor in current working directory
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", {}) -- list open buffers in current neovim instance
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {}) -- list available help tags
