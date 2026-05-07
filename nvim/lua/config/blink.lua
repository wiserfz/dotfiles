local blink = require("blink.cmp")
local blink_type = require("blink.cmp.types")
local util = require("util")
local colorful_menu = require("colorful-menu")

local blink_winblend = function()
  if vim.g.neovide_multigrid then
    return 70
  end
  return vim.o.winblend
end

local M = {}

function M.setup()
  local winblend = blink_winblend()
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  local opts = {
    keymap = {
      ["<C-e>"] = { "hide", "fallback" }, -- hide the completion menu
      ["<CR>"] = { "accept", "fallback" },

      ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },

      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
    },

    -- setup for cmdline completion
    cmdline = {
      enabled = true,
      keymap = {
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Tab>"] = { "show", "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },

        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
      },
      sources = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" or type == "@" then
          return { "cmdline" }
        end
        return {}
      end,
      completion = { ghost_text = { enabled = false } },
    },

    enabled = function()
      local ft_table = { "DressingInput", "TelescopePrompt" }
      return not vim.tbl_contains(ft_table, vim.bo.filetype)
        and vim.bo.buftype ~= "prompt" -- ~= not equal
        and vim.b.completion ~= false
    end,

    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = function(ctx)
            return ctx.mode ~= "cmdline"
          end,
        },
      },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 2 } },
          components = {
            label = {
              text = function(ctx)
                return colorful_menu.blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return colorful_menu.blink_components_highlight(ctx)
              end,
            },
          },
        },
        -- Don't show completion menu automatically on cmdline
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline"
          -- or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
        end,
        border = "rounded",
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
        scrollbar = false,
        winblend = winblend,
      },
      documentation = {
        auto_show = true,
        window = { border = "rounded", scrollbar = false, winblend = winblend },
      },
      trigger = {
        -- these are annoying
        show_on_x_blocked_trigger_characters = { "'", '"', "(", "[", "{" },
      },
      accept = {
        create_undo_point = false,
      },
    },
    signature = {
      enabled = true, -- experimental, can also be provided by `noice` plugin
      window = { show_documentation = false, border = "rounded", winblend = winblend },
    },
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "normal",
      kind_icons = util.icons,
    },
    sources = {
      default = {
        "avante_commands",
        "avante_mentions",
        "avante_files",
        "copilot",
        "lsp",
        "lazydev",
        "path",
        "snippets",
        "buffer",
        "crates",
      },
      providers = {
        avante_commands = {
          name = "avante_commands",
          module = "blink.compat.source",
          score_offset = 90, -- show at a higher priority than lsp
        },
        avante_files = {
          name = "avante_files",
          module = "blink.compat.source",
          score_offset = 100, -- show at a higher priority than lsp
        },
        avante_mentions = {
          name = "avante_mentions",
          module = "blink.compat.source",
          score_offset = 1000, -- show at a higher priority than lsp
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
          opts = {
            max_completions = 1,
            max_attempts = 2,
            kind_icon = " ",
            kind_hl = "SignColumn",
          },
        },
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          fallbacks = { "buffer" },
          transform_items = function(_, items)
            -- filter out text items, since we have the buffer source
            return vim.tbl_filter(function(item)
              return item.kind ~= blink_type.CompletionItemKind.Text
            end, items)
          end,
        },
        crates = {
          name = "crates",
          module = "blink.compat.source",
          score_offset = 100,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
  }

  blink.setup(opts)
end

return M
