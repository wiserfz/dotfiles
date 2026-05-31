local mcp = require("mcphub")

local M = {}

function M.setup()
  ---@module "mcphub"
  ---@type MCPHub.Config
  local opts = {
    auto_approve = true, -- Auto approve mcp tool calls
    auto_toggle_mcp_servers = true,
    extensions = {
      avante = {
        make_slash_commands = true,
      },
    },
    log = {
      level = vim.log.levels.ERROR,
      to_file = true,
      prefix = "MCPHub",
    },
  }

  mcp.setup(opts)
end

return M
