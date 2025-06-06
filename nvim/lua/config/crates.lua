local crates = require("crates")
local lsp = require("config.lspconfig")
local wk = require("which-key")

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
        enabled = true,
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

  wk.add({
    { "<leader>c", group = "Crates" },

    { "<leader>ct", crates.toggle, desc = "Toggle" },
    { "<leader>cr", crates.reload, desc = "Reload" },

    { "<leader>cv", crates.show_versions_popup, desc = "Crates versions popup" },
    { "<leader>cf", crates.show_features_popup, desc = "Crates features popup" },
    { "<leader>cd", crates.show_dependencies_popup, desc = "Crates dependencies popup" },

    { "<leader>cu", crates.update_crate, desc = "Update crate" },
    {
      "<leader>cu",
      crates.update_crates,
      desc = "Update selected crates",
      mode = "v",
    },
    { "<leader>ca", crates.update_all_crates, desc = "Update all crates" },

    { "<leader>cU", crates.upgrade_crate, desc = "Upgrade crate" },
    {
      "<leader>cU",
      crates.upgrade_crates,
      desc = "Upgrade selected crates",
      mode = "v",
    },
    { "<leader>cA", crates.upgrade_all_crates, desc = "Upgrade all crates" },

    { "<leader>cx", crates.expand_plain_crate_to_inline_table, desc = "Expand to inline table" },
    { "<leader>cX", crates.extract_crate_into_table, desc = "Extract into table" },
    { "<leader>cg", crates.use_git_source, desc = "Use git source" },

    -- open official homepage with browser
    { "<leader>cH", crates.open_homepage, desc = "Open homepage" },
    -- open github.com with browser
    { "<leader>cR", crates.open_repository, desc = "Open repository" },
    -- open docs.rs with browser
    { "<leader>cD", crates.open_documentation, desc = "Open documentation" },
    -- open crate.io with browser
    { "<leader>cC", crates.open_crates_io, desc = "Open crates.io" },
  })
end

return M
