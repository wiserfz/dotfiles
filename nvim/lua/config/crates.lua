local crates = require("crates")
local lsp = require("config.lspconfig")
local util = require("util")

local M = {}

function M.setup()
  crates.setup({
    autoupdate_throttle = 50,
    max_parallel_requests = 32,
    completion = {
      crates = {
        enabled = true,
        max_results = 30,
      },
      cmp = {
        use_custom_kind = true,
      },
    },
    lsp = {
      enabled = true,
      on_attach = lsp.on_attach,
      actions = true,
      completion = true,
      hover = true,
    },
  })

  util.map("n", "<leader>ct", crates.toggle)
  util.map("n", "<leader>cr", crates.reload)

  util.map("n", "<leader>cv", crates.show_versions_popup)
  util.map("n", "<leader>cf", crates.show_features_popup)
  util.map("n", "<leader>cd", crates.show_dependencies_popup)

  util.map("n", "<leader>cu", crates.update_crate)
  util.map("v", "<leader>cu", crates.update_crates)
  util.map("n", "<leader>ca", crates.update_all_crates)
  util.map("n", "<leader>cU", crates.upgrade_crate)
  util.map("v", "<leader>cU", crates.upgrade_crates)
  util.map("n", "<leader>cA", crates.upgrade_all_crates)

  -- open official homepage with browser
  util.map("n", "<leader>cH", crates.open_homepage)
  -- open github.com with browser
  util.map("n", "<leader>cR", crates.open_repository)
  -- open docs.rs with browser
  util.map("n", "<leader>cD", crates.open_documentation)
  -- open crate.io with browser
  util.map("n", "<leader>cC", crates.open_crates_io)
end

return M
