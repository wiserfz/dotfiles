-- bridges gap b/w mason & null-ls
return {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
  config = function()
    -- import mason-null-ls plugin safely
    local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
    if not mason_null_ls_status then
      return
    end

    mason_null_ls.setup({
      ensure_installed = nil,
      -- auto-install configured formatters & linters (with null-ls)
      automatic_installation = true,
    })
  end,
}
