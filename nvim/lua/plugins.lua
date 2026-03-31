local M = {}

local util = require("util")

---@param plugin string @plugin name
---@return function @function to setup plugin
local function config(plugin)
  return function()
    require("config." .. plugin).setup()
  end
end

function M.setup()
  -- bootstrap lazy.nvim
  local lazypath = util.join_paths(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=stable", -- latest stable release
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  local lazy = require("lazy")
  lazy.setup({
    {
      -- "tomasr/molokai",
      "rebelot/kanagawa.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = config("kanagawa"),
    },
    -- setting status column
    {
      "luukvbaal/statuscol.nvim",
      lazy = false,
      config = config("statuscol"),
    },
    -- Key mappings
    {
      "folke/which-key.nvim",
      lazy = false,
      config = config("which_key"),
    },
    {
      "christoomey/vim-tmux-navigator", -- tmux & split window navigation
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Tmux navigate left" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Tmux navigate down" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Tmux navigate up" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Tmux navigate right" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Tmux navigate previous" },
      },
    },
    {
      "RRethy/vim-illuminate", -- highlight other uses of word under cursor
      event = "BufReadPost",
      config = config("illuminate"),
    },
    {
      "HiPhish/rainbow-delimiters.nvim", -- rainbow parentheses
      submodules = false,
      event = "BufRead",
    },
    {
      "szw/vim-maximizer",
      event = {
        "BufReadPre",
        "BufNewFile",
      },
      init = function()
        -- disable default key mapping
        vim.g.maximizer_set_default_mapping = 0
        vim.g.maximizer_set_mapping_with_bang = 0
      end,
    },
    {
      "norcalli/nvim-colorizer.lua", -- color highlighter
      event = {
        "BufReadPre",
        "BufNewFile",
      },
      config = function()
        require("colorizer").setup({ "*" }, { RGB = false })
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = config("autopairs"),
    },
    {
      "akinsho/bufferline.nvim", -- file tabpage
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      version = "*",
      config = config("bufferline"),
    },
    {
      "saghen/blink.cmp",
      version = "*",
      event = "VimEnter",
      dependencies = {
        "rafamadriz/friendly-snippets", -- useful snippets
        "fang2hou/blink-copilot",
        "saghen/blink.compat",
        "xzbdmw/colorful-menu.nvim",
      },
      config = config("blink"),
    },
    {
      "numToStr/Comment.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
          config = function()
            local get_option = vim.filetype.get_option
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.filetype.get_option = function(filetype, option)
              return option == "commentstring"
                  and require("ts_context_commentstring.internal").calculate_commentstring()
                or get_option(filetype, option)
            end

            require("ts_context_commentstring").setup({
              enable_autocmd = false,
            })
          end,
        },
      },
      config = function()
        local commentstring = require("ts_context_commentstring.integrations.comment_nvim")

        require("Comment").setup({
          pre_hook = commentstring.create_pre_hook(),
        })
      end,
    },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = config("copilot"),
    },
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      config = config("crates"),
    },
    {
      "mfussenegger/nvim-dap",
      event = "VeryLazy",
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
      },
      config = config("dap"),
    },
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = config("dashboard"),
    },
    {
      "mason-org/mason.nvim",
      dependencies = {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
      },
      config = config("mason"),
    },
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "mason-org/mason-lspconfig.nvim", -- Integration with nvim-lspconfig
        "b0o/schemastore.nvim", -- YAML/JSON schemas
        "saghen/blink.cmp", -- completion
      },
      config = config("lspconfig"),
    },
    {
      "j-hui/fidget.nvim",
      event = "LspAttach",
      config = config("fidget"),
    },
    {
      "nvimdev/lspsaga.nvim",
      event = "LspAttach",
      dependencies = {
        "nvim-treesitter/nvim-treesitter", -- optional
        "nvim-tree/nvim-web-devicons", -- optional
      },
      config = config("lspsaga"),
    },
    -- Linter
    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPre", "BufNewFile" },
      config = config("lint"),
    },
    -- Formatter
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
      config = config("conform"),
    },
    -- Golang
    {
      "ray-x/go.nvim",
      dependencies = { -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
      -- event = { "CmdlineEnter" },
      ft = { "go", "gomod" },
      -- build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
      config = config("go"),
    },
    -- Rust
    {
      "mrcjkb/rustaceanvim",
      dependencies = {
        "neovim/nvim-lspconfig",
      },
      version = "^7", -- Recommended
      lazy = false, -- This plugin is already lazy
      ft = "rust",
      config = config("rust"),
    },
    -- Lua
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        integrations = {
          lspconfig = false,
          cmp = false,
        },
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          { path = "lazy.nvim", words = { "LazyVim" } },
        },
      },
    },
    -- Indent
    {
      "lukas-reineke/indent-blankline.nvim",
      event = { "BufReadPre", "BufNewFile" },
      main = "ibl",
      config = config("indent-line"),
    },
    -- Git
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = config("gitsigns"),
    },
    -- ConflictMarker, highlight conflict marker and jump between conflict by [x and ]x
    {
      "rhysd/conflict-marker.vim",
      event = {
        "BufReadPre",
        "BufNewFile",
      },
    },
    -- Leetcode
    {
      "kawre/leetcode.nvim",
      build = ":TSUpdate html",
      dependencies = {
        "nvim-telescope/telescope.nvim",
        -- "ibhagwan/fzf-lua",
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
      config = config("leetcode"),
    },
    -- WARN: lualine background transparent not work well with neovide
    -- see: https://github.com/neovide/neovide/issues/2275
    {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = config("lualine"),
    },
    {
      "nvim-tree/nvim-tree.lua", -- file explorer
      dependencies = {
        "nvim-tree/nvim-web-devicons", -- for file icons
      },
      config = config("nvim-tree"),
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = { "BufReadPre", "BufNewFile" },
      config = true,
    },
    {
      "nvim-telescope/telescope.nvim", -- fuzzy finder
      branch = "master",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim", -- dependency for better sorting performance
          build = "make",
        },
        "nvim-tree/nvim-web-devicons",
        "folke/todo-comments.nvim",
        "nvim-telescope/telescope-dap.nvim",
      },
      config = config("telescope"),
    },
    {
      "folke/todo-comments.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = { "nvim-lua/plenary.nvim" },
      config = config("todo-comment"),
    },
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false, -- load treesitter at startup
      branch = "main",
      build = ":TSUpdate",
      config = config("treesitter"),
    },
    {
      "andymass/vim-matchup",
      dependencies = "tpope/vim-repeat",
      init = function()
        -- recognize only symbols in strings and comments (and not words like `for`
        -- or `end`)
        vim.g.matchup_delim_noskips = 1
        -- WARN: when set the matchup offscreen feature with `method = "popup"` and
        -- enable the matchup deferred feature have bug with `nvim-ufo` plugin
        -- which makes `statuscolumn` attribute error and the relative number incorrent.
        --
        -- And there is an issue for the matachup offscreen feature with `method = "popup"`,
        -- see: https://github.com/andymass/vim-matchup/issues/313
        -- vim.g.matchup_matchparen_offscreen = { method = "popup", syntax_hl = 1 }
        vim.g.matchup_matchparen_offscreen = {}
        -- Enable delayed matching for better performance.
        vim.g.matchup_matchparen_deferred = 1
        -- Disable considering quotes (single/double) as possible matches
        vim.g.matchup_treesitter_enable_quotes = false
        -- Disable show virtual text at virtual end of a block
        vim.g.matchup_treesitter_disable_virtual_text = true
        -- Disable double-click map to select the whole current scope (`va%` works well instead)
        vim.g.matchup_mouse_enabled = 0
      end,
    },
    {
      "kevinhwang91/nvim-ufo",
      event = "BufReadPost",
      dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        "kevinhwang91/promise-async",
        "luukvbaal/statuscol.nvim",
      },
      config = config("ufo"),
    },
    -- {
    --   "sontungexpt/url-open",
    --   event = "VeryLazy",
    --   cmd = "URLOpenUnderCursor",
    --   config = config("url"),
    -- },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      config = config("markdown"),
    },
    {
      "folke/sidekick.nvim", -- neovim AI sidekick
      config = config("sidekick"),
    },
    {
      "folke/noice.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      config = config("noice"),
    },
    {
      "mcauley-penney/visual-whitespace.nvim",
      event = "ModeChanged *:[vV\22]",
      config = config("visual-whitespace"),
    },
  })
end

return M
