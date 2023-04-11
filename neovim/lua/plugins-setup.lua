-- setup plugins manager - Packer

-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("config") .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
  return
end

-- add list of plugins to install
return packer.startup({
  function(use)
    -- Packer manage itself
    use("wbthomason/packer.nvim")

    -- filesystem navigation
    use({
      "nvim-tree/nvim-tree.lua", -- file explorer
      requires = "nvim-tree/nvim-web-devicons", -- for file icons
    })
    use({
      "akinsho/bufferline.nvim", -- file tabpage
      tag = "v3.*",
      requires = "nvim-tree/nvim-web-devicons",
    })

    use("nvim-lua/plenary.nvim") -- lua functions that many plugins use

    -- color theme
    -- use("folke/tokyonight.nvim")
    -- use("navarasu/onedark.nvim")
    use("rebelot/kanagawa.nvim")

    -- tmux & split window navigation
    use("christoomey/vim-tmux-navigator")

    -- maximizes and restores current window
    use("szw/vim-maximizer")

    -- essential plugins ## learn
    use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)
    use("inkarkat/vim-ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

    -- commenting with gc
    use("numToStr/Comment.nvim")

    -- statusline
    use({
      "nvim-lualine/lualine.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons",
        opt = true,
      },
    })
    -- trouble highlight
    use({
      "folke/trouble.nvim", -- show in a sigle panel lsp error and warnings
      requires = "kyazdani42/nvim-web-devicons",
    })
    use("folke/lsp-colors.nvim") -- automatically creates missing LSP diagnostics highlight

    -- fuzzy finding w/ telescope
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
    use("nvim-telescope/telescope-media-files.nvim") -- image files preview in telescope

    -- autocompletion
    use("hrsh7th/nvim-cmp") -- completion plugin
    use("hrsh7th/cmp-buffer") -- source for text in buffer
    use("hrsh7th/cmp-path") -- source for file system paths

    -- snippets
    use("L3MON4D3/LuaSnip") -- snippet engine
    use("saadparwaiz1/cmp_luasnip") -- for autocompletion
    use("rafamadriz/friendly-snippets") -- useful snippets

    -- managing & installing lsp servers, linters & formatters
    use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
    use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

    -- configuring lsp servers
    use("neovim/nvim-lspconfig") -- easily configure language servers
    use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
    use({
      "glepnir/lspsaga.nvim", -- enhanced lsp uis
      branch = "main",
      requires = "nvim-tree/nvim-web-devicons",
    })
    use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

    -- formatting & linting
    use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
    use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

    -- treesitter configuration
    use({
      "nvim-treesitter/nvim-treesitter",
      run = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
      end,
    })

    -- auto closing
    use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
    use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

    -- git integration
    use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

    -- TODO comments
    use("folke/todo-comments.nvim")

    -- rust
    use("simrat39/rust-tools.nvim") -- tools to automatically set up lspconfig for rust-analyzer
    use({
      "saecki/crates.nvim", -- manager crates.io dependencies
      tag = "v0.3.0",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup()
      end,
    })

    -- golang
    use({
      "ray-x/go.nvim",
      requires = "ray-x/guihua.lua", -- floating window support
    })

    -- debugging
    use({
      "rcarriga/nvim-dap-ui",
      requires = "mfussenegger/nvim-dap",
    })
    use("nvim-telescope/telescope-dap.nvim")

    use("HiPhish/nvim-ts-rainbow2") -- rainbow parentheses
    use("lukas-reineke/indent-blankline.nvim") -- indent blankline

    use("RRethy/vim-illuminate") -- highlight other uses of word under cursor

    use("m-demare/hlargs.nvim") -- leverage Tree-sitter and highlight argument definitions

    use("j-hui/fidget.nvim") -- provide a UI for nvim-lsp's progress handler

    -- use("Pocco81/auto-save.nvim") -- automatically save your changes

    use("hrsh7th/cmp-nvim-lsp-signature-help") -- displaying function signatures
    use("hrsh7th/cmp-nvim-lua")

    -- good folding
    use({
      "kevinhwang91/nvim-ufo",
      requires = {
        "kevinhwang91/promise-async",
        "luukvbaal/statuscol.nvim",
      },
    })

    use({
      "andymass/vim-matchup",
      setup = function()
        -- may set any options here
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
    })

    -- Jedi is a static analysis tool for Python
    use("zchee/deoplete-jedi")
    -- leetcode for neovim
    use("mbledkowski/neuleetcode.vim")

    -- Automatically set up configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    package_root = vim.fn.stdpath("config") .. "/site/pack/",
  },
})
