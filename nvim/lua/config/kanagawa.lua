local scheme = require("kanagawa")
local lib_color = require("kanagawa.lib.color")

-- local cus_colors = {
--   mars_green = "#008C8C",
--   prussian_blue = "#003153",
--   sennelier_yellow = "#F9DC24",
--   klein_blue = "#002FA7",
--   hermes_orange = "#E85827",
--   tiffany_blue = "#81D8D0",
--   burgundy = "#800020",
--   bordeaux = "#4C0009",
--   mummy_brown = "#8F4B28",
--   china_red = "#B05923",
-- }

local M = {}

-- monokai theme
function M.setup()
  ---@module "kanagawa"
  ---@type KanagawaConfig
  local opts = {
    keywordStyle = { italic = true, bold = true },
    commentStyle = { italic = true },
    variablebuiltinStyle = { italic = true },
    transparent = true,
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
    overrides = function(colors)
      local theme = colors.theme
      local function blend_bg(diag)
        return { fg = diag, bg = lib_color(diag):blend(theme.ui.bg, 0.95):to_hex() }
      end
      return {
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },

        -- Save an hlgroup with dark background and dimmed foreground
        -- so that you can use it where your still want darker windows.
        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

        -- Popular plugins that open floats will link to NormalFloat by default;
        -- set their background accordingly if you wish to keep them dark and borderless
        LazyNormal = { bg = theme.ui.bg, fg = theme.ui.fg_dim },
        MasonNormal = { bg = theme.ui.bg, fg = theme.ui.fg_dim },

        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },

        -- set visual mode bg to be more visible
        Visual = { bg = theme.ui.bg_p2 },

        TelescopeTitle = { fg = theme.ui.special, bold = true },
        TelescopePromptBorder = { fg = theme.ui.fg_dim, bg = "none" },
        TelescopeResultsBorder = { fg = theme.ui.fg_dim, bg = "none" },
        TelescopePreviewBorder = { fg = theme.ui.fg_dim, bg = "none" },
        DiagnosticVirtualTextError = blend_bg(theme.diag.error),
        DiagnosticVirtualTextWarn = blend_bg(theme.diag.warning),
        DiagnosticVirtualTextHint = blend_bg(theme.diag.hint),
        DiagnosticVirtualTextInfo = blend_bg(theme.diag.info),
        DiagnosticVirtualTextOk = blend_bg(theme.diag.ok),
      }
    end,
  }

  scheme.setup(opts)

  vim.cmd("colorscheme kanagawa-wave")

  -- Highlight colors
  vim.cmd([[
    hi GitSignsAdd guibg=#193549 guifg=#3ad900
    hi GitSignsChange guibg=#193549 guifg=#ffc600
    hi GitSignsDelete guibg=#193549 guifg=#ff2600
    hi WinSeparator guifg=#272727
    hi CurSearch guifg=#000000 guibg=#ffaf00
    " hi DiffAdd guifg=#f0cdc9 guibg=#567c44
    " hi DiffChange guifg=#fefefe guibg=#404ea4
    " hi DiffDelete gui=bold guifg=#c3c3c3 guibg=#a22e26
    " hi Normal guifg=#D4D4D4 guibg=#1E1E1E
    hi MatchParen cterm=reverse gui=reverse
    " hi! link NormalFloat Normal
  ]])
end

return M
