local M = {}

--@param mode string @The vim mode
--@param lhs string @The keybinding
--@param rhs string @The action
--@param opts table @The keybinding options
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

--@return string @Unix file path separator
function M.path_separator()
  -- if M.is_windows then
  --   return "\\"
  -- end
  return "/"
end

--@vararg string @Paths to join
--@return string @The joined path
function M.join_paths(...)
  local separator = M.path_separator()
  return table.concat({ ... }, separator)
end

return M
