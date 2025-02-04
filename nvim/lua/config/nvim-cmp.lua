-- local kind_icons = {
--   Boolean = "",
--   Character = "",
--   Text = "",
--   Method = "󰆧",
--   Function = "󰊕",
--   Constructor = "",
--   Field = "󰇽",
--   Variable = "󰂡",
--   Class = "󰠱",
--   Interface = "",
--   Module = "",
--   Property = "󰜢",
--   Unit = "",
--   Value = "󰎠",
--   Enum = "",
--   Keyword = "󰌋",
--   Snippet = "",
--   Color = "󰏘",
--   File = "󰈙",
--   Reference = "",
--   Folder = "󰉋",
--   EnumMember = "",
--   Constant = "󰏿",
--   Struct = "",
--   Event = "",
--   Operator = "󰆕",
--   TypeParameter = "󰅲",
--   Copilot = "",
--   Number = "",
--   Parameter = "",
--   String = "󰅳",
-- }
-- find more here: https://www.nerdfonts.com/cheat-sheet

local cmp = require("cmp")

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

--@return boolean @Whether has words before
local function has_words_before()
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local copilot_cmp = require("copilot_cmp.comparators")
-- load vs-code like snippets from plugins (e.g. friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- set copilot symbol color
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#7539DE" })

local M = {}

function M.setup()
  -- configure nvim
  cmp.setup({
    completion = {
      completeopt = "menu,menuone,preview,noselect",
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), -- previous suggestion
      ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), -- next suggestion
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-s>"] = cmp.mapping.complete({ -- show completion suggestions
        config = {
          sources = {
            { name = "copilot" },
          },
        },
      }),
      ["<C-e>"] = cmp.mapping.close(), -- close completion window
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        -- select = false,
      }),
      ["<Tab>"] = function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = vim.schedule_wrap(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end),
    }),
    -- sources for autocompletion
    sources = cmp.config.sources({
      { name = "copilot", group_index = 2 },
      {
        name = "nvim_lsp",
        option = {
          markdown_oxide = {
            keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
          },
        },
        group_index = 2,
      },
      { name = "nvim_lsp_signature_help", group_index = 3 }, -- display function signatures with current parameter emphasized
      { name = "path", group_index = 3 }, -- file system paths
      {
        name = "luasnip", -- snippets
        option = { use_show_condition = false, show_autosnippets = false },
        group_index = 3,
      },
      { name = "buffer", group_index = 3 }, -- text within current buffer
      -- { name = "nvim_lua", group_index = 3 }, -- complete neovim's Lua runtime API such vim.lsp.*
    }),
    -- configure lspkind for vs-code like icons
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = lspkind.cmp_format({
        mode = "symbol", -- show only symbol annotations
        maxwidth = 50,
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        symbol_map = { Copilot = "" },
      }),
    },
    view = {
      entries = { name = "custom", selection_order = "near_cursor" },
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        copilot_cmp.prioritize,
        copilot_cmp.score,

        -- Below is the default comparator list and order for nvim-cmp
        cmp.config.compare.offset,
        -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  })
end

return M
