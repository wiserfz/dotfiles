return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  tag = "stable",
  config = function()
    local status, crates = pcall(require, "crates")
    if not status then
      return
    end

    crates.setup()
    local function show_documentation()
      local filetype = vim.bo.filetype
      if vim.tbl_contains({ "vim", "help" }, filetype) then
        vim.cmd("h " .. vim.fn.expand("<cword>"))
      elseif vim.tbl_contains({ "man" }, filetype) then
        vim.cmd("Man " .. vim.fn.expand("<cword>"))
      elseif vim.fn.expand("%:t") == "Cargo.toml" and crates.popup_available() then
        crates.show_popup()
      else
        vim.lsp.buf.hover()
      end
    end

    local opts = { noremap = true, silent = true }
    local keymap = vim.keymap

    keymap.set("n", "K", show_documentation, opts)
    keymap.set("n", "<leader>ct", crates.toggle, opts)
    keymap.set("n", "<leader>cr", crates.reload, opts)

    keymap.set("n", "<leader>cv", crates.show_versions_popup, opts)
    keymap.set("n", "<leader>cf", crates.show_features_popup, opts)
    keymap.set("n", "<leader>cd", crates.show_dependencies_popup, opts)

    keymap.set("n", "<leader>cu", crates.update_crate, opts)
    keymap.set("v", "<leader>cu", crates.update_crates, opts)
    keymap.set("n", "<leader>ca", crates.update_all_crates, opts)
    keymap.set("n", "<leader>cU", crates.upgrade_crate, opts)
    keymap.set("v", "<leader>cU", crates.upgrade_crates, opts)
    keymap.set("n", "<leader>cA", crates.upgrade_all_crates, opts)

    -- open official homepage with browser
    keymap.set("n", "<leader>cH", crates.open_homepage, opts)
    -- open github.com with browser
    keymap.set("n", "<leader>cR", crates.open_repository, opts)
    -- open docs.rs with browser
    keymap.set("n", "<leader>cD", crates.open_documentation, opts)
    -- open crate.io with browser
    keymap.set("n", "<leader>cC", crates.open_crates_io, opts)
  end,
}
