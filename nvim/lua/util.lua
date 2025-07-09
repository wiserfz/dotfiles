local M = {}

---@param mode string @The vim mode
---@param lhs string @The keybinding
---@param rhs string @The action
---@param opts table @The keybinding options
function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

---@return string @Unix file path separator
function M.path_separator()
  -- if M.is_windows then
  --   return "\\"
  -- end
  return "/"
end

---@vararg string @Paths to join
---@return string @The joined path
function M.join_paths(...)
  local separator = M.path_separator()
  return table.concat({ ... }, separator)
end

M.diagnostics = {
  ERROR = " ",
  WARN = " ",
  HINT = " ",
  INFO = " ",
}

M.git = {
  Added = " ",
  Modified = " ",
  Removed = " ",
}

M.dap = {
  breakpoint = " ",
  breakpoint_condition = " ",
  log_point = " ",
  stopped = " ",
  breakpoint_rejected = " ",
  pause = " ",
  play = " ",
  step_into = " ",
  step_over = " ",
  step_out = " ",
  step_back = " ",
  run_last = " ",
  terminate = " ",
}

-- find more here: https://www.nerdfonts.com/cheat-sheet
M.icons = {
  Array = " ",
  Boolean = "󰨙 ",
  Class = " ",
  Codeium = "󰘦 ",
  Color = " ",
  Control = " ",
  Collapsed = " ",
  Constant = "󰏿 ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = "󰊕 ",
  Module = " ",
  Namespace = "󰦮 ",
  Null = " ",
  Number = "󰎠 ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = "󱄽 ",
  String = " ",
  Struct = "󰆼 ",
  TabNine = "󰏚 ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = "󰀫 ",
}

---@return string @The current CPU arch
function M.arch()
  local handle = io.popen("uname -m")
  if handle == nil then
    return "unknown"
  end
  local arch = handle:read("*a")
  handle:close()

  return arch
end

return M
