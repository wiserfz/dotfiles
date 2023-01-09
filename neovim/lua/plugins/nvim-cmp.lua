-- import nvim-cmp plugin safely
local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
  return
end

-- import luasnip plugin safely
local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
  return
end

-- import lspkind plugin safely
local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
  return
end

-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option("updatetime", 300)

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  }),
  -- sources for autocompletion
  sources = cmp.config.sources({
    { name = "path" }, -- file system paths
    { name = "nvim_lsp", keyword_length = 1, priority = 10 }, -- lsp
    { name = "luasnip", keyword_length = 1, priority = 7 }, -- snippets
    { name = "nvim_lsp_signature_help", priority = 8 }, -- display function signatures with current parameter emphasized
    { name = "nvim_lua", keyword_length = 1, priority = 8 }, -- complete neovim's Lua runtime API such vim.lsp.*
    { name = "buffer", keyword_length = 1, priority = 5 }, -- text within current buffer
  }),
  window = {
    completion = {
      cmp.config.window.bordered(),
      col_offset = 3,
      side_padding = 1,
    },
    documentation = cmp.config.window.bordered(),
  },
  -- configure lspkind for vs-code like icons
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text", -- show only symbol annotations
      maxwidth = 50,
      ellipsis_char = "...",
    }),
  },
  preselect = cmp.PreselectMode.None,
})
