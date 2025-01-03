local blink = require("blink.cmp")
local util = require("util")

local M = {}

function M.setup()
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  local opts = {
    keymap = {
      ["<C-e>"] = { "hide", "fallback" }, -- hide the completion menu
      ["<CR>"] = { "accept", "fallback" },

      ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },

      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },

    -- Disable for some filetypes
    enabled = function()
      return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
        and vim.bo.buftype ~= "prompt"
        and vim.b.completion ~= false
    end,

    completion = {
      list = {
        selection = function(ctx)
          return ctx.mode == "cmdline" and "auto_insert" or "manual"
        end,
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
        -- Don't show completion menu automatically when searching
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
        end,
      },
      documentation = {
        auto_show = true,
      },
      trigger = {
        -- these are annoying
        show_on_x_blocked_trigger_characters = { "'", '"', "(", "[", "{" },
      },
    },
    signature = {
      enabled = true, -- experimental, can also be provided by `noice` plugin
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
      kind_icons = util.icons,
    },
    sources = {
      default = { "copilot", "lsp", "path", "luasnip", "buffer", "crates" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
          transform_items = function(_, items)
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"

            for _, item in ipairs(items) do
              item.kind = kind_idx
            end
            return items
          end,
        },
        crates = {
          name = "crates",
          module = "blink.compat.source",
          score_offset = 10,
        },
      },
    },
  }

  blink.setup(opts)

  -- highlight for Copilot completion items
  vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { fg = "#7539DE" })
end

return M
