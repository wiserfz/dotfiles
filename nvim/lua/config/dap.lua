local dap = require("dap")
local dapui = require("dapui")
local wk = require("which-key")

local M = {}

--@param suggestion string @The arguments for the command
--@return table @The command arguments
local function input_cmd_args(suggestion)
  local cmd_args_str = vim.fn.input("Args: ", suggestion)
  return vim.split(cmd_args_str, " ", { plain = true, trimempty = true })
end

--@return table @The init commands
local function init_commands()
  local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

  local script_import = 'command script import "'
    .. rustc_sysroot
    .. '/lib/rustlib/etc/lldb_lookup.py"'
  local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

  local commands = {}
  local file = io.open(commands_file, "r")
  if file then
    for line in file:lines() do
      table.insert(commands, line)
    end
    file:close()
  end
  table.insert(commands, 1, script_import)

  return commands
end

function M.setup()
  local codelldb_path = os.getenv("HOME")
    .. "/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      -- CHANGE THIS to your path!
      command = codelldb_path,
      args = { "--port", "${port}" },
    },
  }

  -- rust
  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        local suggestion = M.last_program or (vim.fn.getcwd() .. "/target/debug/")
        M.last_program = vim.fn.input("Path to executable: ", suggestion, "file")
        return M.last_program
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = function()
        return input_cmd_args("")
      end,
      runInTerminal = false,
      initCommands = init_commands,
    },
  }

  vim.fn.sign_define(
    "DapBreakpoint",
    { text = "", texthl = "ErrorMsg", linehl = "", numhl = "" }
  )
  -- vim.fn.sign_define(
  --   "DapBreakpoint",
  --   { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" }
  -- )
  -- vim.fn.sign_define(
  --   "DapLogPoint",
  --   { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" }
  -- )
  -- vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "", numhl = "" })

  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
    expand_lines = true,
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.5 },
          { id = "breakpoints", size = 0.15 },
          { id = "stacks", size = 0.2 },
          -- { id = "watches",     size = 0.15 }
        },
        size = 70,
        position = "left",
      },
      {
        elements = {
          { id = "repl", size = 0.65 },
          { id = "console", size = 0.35 },
        },
        size = 20,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
  })
  -- automatically open ui
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  wk.add({
    { "<f5>", dap.continue, desc = "Debug continue" },
    { "<f10>", dap.step_over, desc = "Debug step over" },
    { "<f11>", dap.step_into, desc = "Debug step into" },
    { "<f12>", dap.step_out, desc = "Debug step out" },

    { "<leader>d", group = "Debug" },
    { "<leader>de", dapui.toggle, desc = "Toggle debug UI" },

    { "<leader>db", dap.toggle_breakpoint, desc = "Toggle debug breakpoint" },
    {
      "<leader>dc",
      function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Conditional debug breakpoint",
    },
    {
      "<leader>dl",
      function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log print message: "))
      end,
      desc = "Log debug breakpoint",
    },
    { "<leader>dR", dap.run_last, desc = "Debug run last config", silent = false },
    { "<leader>dr", dap.restart, desc = "Debug restart", silent = false },
    { "<leader>dT", dap.terminate, desc = "Debug terminate", silent = false },
    { "<leader>dD", dap.disconnect, desc = "Debug disconnect", silent = false },
    { "<leader>dq", dap.close, desc = "Debug close" },
  })
end

return M
