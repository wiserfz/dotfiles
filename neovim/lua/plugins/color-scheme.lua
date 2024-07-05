-- color theme
return {
  -- "tomasr/molokai",
  "rebelot/kanagawa.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- vim.cmd([[colorscheme molokai]])
    local status, scheme = pcall(require, "kanagawa")
    if not status then
      print("Colorscheme of kanagawa not found!")
      return
    end

    scheme.setup({
      keywordStyle = { italic = false, bold = true },
      overrides = function(colors)
        local theme = colors.theme
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
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        }
      end,
    })
    scheme.load("wave")

    -- custom highlights
    vim.cmd([[
      hi FoldColumn guifg=gray guibg=#232526
      hi GitSignsAdd guibg=#193549 guifg=#3ad900
      hi GitSignsChange guibg=#193549 guifg=#ffc600
      hi GitSignsDelete guibg=#193549 guifg=#ff2600
      hi WinSeparator guifg=#272727
      hi CurSearch guifg=#000000 guibg=#ffaf00
      " hi DiffAdd guifg=#f0cdc9 guibg=#567c44
      " hi DiffChange guifg=#fefefe guibg=#404ea4
      " hi DiffDelete gui=bold guifg=#c3c3c3 guibg=#a22e26
      " hi Normal guifg=#D4D4D4 guibg=#1E1E1E
      " hi MatchParen cterm=reverse ctermbg=82 ctermfg=22
      " hi Visual guibg=#403D3D ctermbg=238
      " hi! link NormalFloat Normal
    ]])
  end,
}
