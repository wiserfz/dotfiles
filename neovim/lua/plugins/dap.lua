return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  config = function()
    local status, dap = pcall(require, "dap")
    if not status then
      return
    end

    vim.api.nvim_set_hl(0, "red", { fg = "#ec2323" })
    -- vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
    -- vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
    -- vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
    -- vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "red", linehl = "", numhl = "" })
    local codelldb_path = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb"
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
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    local keymap = vim.keymap
    local options = { noremap = false, silent = true }

    -- debugging with DAP
    keymap.set("n", "<F5>", dap.continue, options)
    keymap.set("n", "<F10>", dap.step_over, options)
    keymap.set("n", "<F11>", dap.step_into, options)
    keymap.set("n", "<F12>", dap.step_out, options)
    keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    keymap.set(
      "n",
      "<leader>B",
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      { desc = "Conditional Breakpoint" }
    )
    keymap.set(
      "n",
      "<leader>lp",
      "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      { desc = "Log Breakpoint" }
    )
    keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "REPL" })
    keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Run Last Config" })

    keymap.set("n", "<leader>dT", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Terminate" })
    keymap.set(
      "n",
      "<leader>dD",
      "<cmd>lua require'dap'.disconnect()<CR> require'dap'.close()<CR>",
      { desc = "Disconnect & Close" }
    )

    keymap.set("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Toggle debug UI" })
    keymap.set("n", "<leader>de", "<cmd>lua require'dapui'.eval()<CR>", { desc = "Evaluate under cursor" })
  end,
}
