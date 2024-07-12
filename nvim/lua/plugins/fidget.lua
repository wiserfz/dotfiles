return {
  "j-hui/fidget.nvim", -- provide a UI for nvim-lsp's progress handler
  event = "LspAttach",
  opts = {
    progress = {
      display = {
        done_icon = "",
        done_ttl = 2,
      },
      ignore = { "null-ls" },
    },
    notification = {
      window = {
        max_height = 4,
        normal_hl = "FidgetNormal",
      },
    },
  },
}
