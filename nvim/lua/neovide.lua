local M = {}

local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

-- Add keybinds to change transparency
local change_transparency = function(delta)
  vim.g.neovide_opacity = vim.g.neovide_opacity + delta
end

function M.setup()
  if vim.g.neovide == nil then
    return
  end

  vim.g.neovide_macos_simple_fullscreen = true

  -- Change font size with ctrl + and ctrl -
  vim.g.neovide_scale_factor = 1.0
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
  end)

  vim.g.neovide_text_gamma = 0.8
  vim.g.neovide_text_contrast = 0.1

  -- Set transparency and background color (title bar color)
  vim.g.neovide_opacity = 0.8
  -- command + ] to increase transparency
  vim.keymap.set({ "n", "v", "o" }, "<D-]>", function()
    change_transparency(0.01)
  end)
  -- command + [ to decrease transparency
  vim.keymap.set({ "n", "v", "o" }, "<D-[>", function()
    change_transparency(-0.01)
  end)

  -- Set duration for the animation of change window position
  vim.g.neovide_position_animation_length = 0.3

  -- Set duration for the animation of scoll cursor
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_scroll_animation_far_lines = 10

  -- Set floating window transparency
  vim.o.winblend = 40

  vim.g.neovide_floating_blur_amount_x = 10.0
  vim.g.neovide_floating_blur_amount_y = 10.0

  -- vim.g.neovide_fullscreen = true
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_cursor_vfx_mode = "railgun"

  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
end

return M
