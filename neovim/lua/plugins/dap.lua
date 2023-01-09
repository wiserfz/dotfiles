local status, dap = pcall(require, "dap")

if not status then
  return
end

vim.api.nvim_set_hl(0, "red", { fg = "#ec2323" })
-- vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
-- vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
-- vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
-- vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "red", linehl = "", numhl = "" })

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = "/Users/wiser/.local/codelldb/extension/adapter/codelldb",
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
