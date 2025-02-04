local dap = require("dap")
local dapui = require("dapui")
local util = require("util")

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

  -- debugging with DAP
  util.map("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>")
  util.map("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>")
  util.map("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>")
  util.map("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>")
  util.map(
    "n",
    "<leader>b",
    "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
    { desc = "Toggle Breakpoint" }
  )
  util.map(
    "n",
    "<leader>B",
    "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { desc = "Conditional Breakpoint" }
  )
  util.map(
    "n",
    "<leader>lp",
    "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { desc = "Log Breakpoint" }
  )
  util.map("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "REPL" })
  util.map("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run Last Config" })

  util.map("n", "<leader>dT", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate" })
  util.map(
    "n",
    "<leader>dD",
    "<cmd>lua require'dap'.disconnect()<CR> require'dap'.close()<CR>",
    { desc = "Disconnect & Close" }
  )

  util.map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle debug UI" })
  util.map(
    "n",
    "<leader>de",
    "<cmd>lua require'dapui'.eval()<CR>",
    { desc = "Evaluate under cursor" }
  )
end

return M
