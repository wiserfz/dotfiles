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
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  local lazy = require("lazy")
  lazy.setup({
    -- Key mappings
    {
      "folke/which-key.nvim",
      lazy = false,
      priority = 1000,
      config = config("which_key"),
    },
    {
      -- "tomasr/molokai",
      "rebelot/kanagawa.nvim",
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = config("kanagawa"),
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
    "HiPhish/rainbow-delimiters.nvim", -- rainbow parentheses
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
      version = "4.*",
      config = config("bufferline"),
    },
    {
      "saghen/blink.cmp",
      version = "*",
      event = "VimEnter",
      dependencies = {
        "rafamadriz/friendly-snippets", -- useful snippets
        "giuxtaposition/blink-cmp-copilot",
        "saghen/blink.compat",
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
      event = { "BufReadPre", "BufNewFile" },
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
    -- LSP
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim", -- Integration with nvim-lspconfig
        "b0o/schemastore.nvim", -- YAML/JSON schemas
        "saghen/blink.cmp", -- completion
        {
          "folke/neodev.nvim",
          opts = {
            library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
          },
        },
      },
      config = config("lspconfig"),
    },
    {
      "williamboman/mason.nvim",
      event = "VeryLazy",
      config = config("mason"),
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
      "nvimtools/none-ls.nvim",
      dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "gbprod/none-ls-shellcheck.nvim",
      },
      config = config("none-ls"),
    },
    {
      "jay-babu/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      config = config("mason-null-ls"),
    },
    -- {
    --   "mfussenegger/nvim-lint",
    --   event = { "BufReadPre", "BufNewFile" },
    --   config = config("lint"),
    -- },
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
      version = "v5", -- Recommended
      lazy = false, -- This plugin is already lazy
      ft = { "rust" },
      config = config("rust"),
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
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      lazy = "leetcode.nvim" ~= vim.fn.argv()[1],
      config = function()
        require("leetcode").setup({
          lang = "golang",
          cn = { -- leetcode.cn
            enabled = true,
          },
          storage = {
            home = os.getenv("HOME") .. "/Workspace/leetcode",
          },
          logging = false,
          arg = "leetcode.nvim",
        })

        local wk = require("which-key")

        wk.add({
          noremap = false,
          silent = true,

          { "<leader>l", group = "Leetcode" },

          { "<leader>ll", "<cmd>Leet list<cr>", desc = "Problem list" },
          { "<leader>lr", "<cmd>Leet run<cr>", desc = "Run current solution" },
          { "<leader>ls", "<cmd>Leet submit<cr>", desc = "Subimt current solution" },
          { "<leader>lo", "<cmd>Leet open<cr>", desc = "Open current problem" },
          { "<leader>lc", "<cmd>Leet console<cr>", desc = "Open console for current problem" },
          {
            "<leader>lu",
            "<cmd>Leet cookie update<CR>",
            desc = "Update cookie",
          },
        })
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = config("lualine"),
    },
    {
      "andymass/vim-matchup",
      dependencies = "tpope/vim-repeat",
      event = "CursorMoved",
      init = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" } -- Don't display off-screen matches
      end,
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
      tag = "0.1.8",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim", -- dependency for better sorting performance
          build = "make",
        },
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-media-files.nvim", -- image files preview in telescope
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
      dependencies = {
        -- "nvim-treesitter/nvim-treesitter-context",
        "andymass/vim-matchup",
        "windwp/nvim-ts-autotag",
      },
      build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
      end,
      event = "VeryLazy",
      config = config("treesitter"),
    },
    -- WARN: Neovide has something wrong with nvim-ufo plugin,
    -- it doesn't work well when click on folds can't open.
    -- see https://github.com/neovide/neovide/issues/2815
    {
      "kevinhwang91/nvim-ufo",
      event = "BufReadPost",
      dependencies = {
        "neovim/nvim-lspconfig",
        "kevinhwang91/promise-async",
        {
          "luukvbaal/statuscol.nvim",
          config = config("statuscol"),
        },
      },
      config = config("ufo"),
    },
    {
      "sontungexpt/url-open",
      event = "VeryLazy",
      cmd = "URLOpenUnderCursor",
      config = config("url"),
    },
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
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim", -- Optional
        {
          "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
          opts = {
            input = {
              title_pos = "center",
            },
          },
        },
      },
      config = config("codecompanion"),
    },
    {
      "echasnovski/mini.animate", -- Animate common Neovim actions
      enabled = function()
        return vim.g.neovide == nil and util.arch() ~= "arm64"
      end,
      version = false,
      config = config("animation"),
    },
  })
end

return M
