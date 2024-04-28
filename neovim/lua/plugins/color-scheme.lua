-- color theme
return {
  -- "folke/tokyonight.nvim"
  -- "navarasu/onedark.nvim"
  "rebelot/kanagawa.nvim",
  config = function()
    local status, scheme = pcall(require, "kanagawa")
    if not status then
      print("Colorscheme of kanagawa not found!")
      return
    end

    -- for onedark color scheme
    -- scheme.setup({
    --   style = "darker",
    --   term_colors = true, -- Change terminal color as per the selected theme style
    --   lualine = {
    --     transparent = true, -- lualine center bar transparency
    --   },
    -- })

    -- scheme.load()

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
    vim.cmd("colorscheme kanagawa-wave")

    -- Highlight colors
    vim.cmd([[
      hi CursorLineNr guifg=#7e9cd8
      hi FoldColumn guifg=#29292c guibg=#26292c
      hi GitSignsAdd guibg=#193549 guifg=#3ad900
      hi GitSignsChange guibg=#193549 guifg=#ffc600
      hi GitSignsDelete guibg=#193549 guifg=#ff2600
      hi ColorColumn guifg=NONE guibg=#204563 gui=NONE
      hi MatchParen cterm=bold gui=bold guifg=#FD9F4E guibg=#7B7C7C
    ]])
  end,
}
