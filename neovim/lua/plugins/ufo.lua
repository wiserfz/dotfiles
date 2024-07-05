------------------------------------
-- Nvim UFO - GOOD FOLDING      ----
------------------------------------
return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  dependencies = {
    "kevinhwang91/promise-async",
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        local builtin = require("statuscol.builtin")
        require("statuscol").setup({
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
            {
              sign = {
                namespace = { "diagnostic" },
                maxwidth = 1,
                colwidth = 2,
                auto = true,
                foldclosed = true,
              },
              click = "v:lua.ScSa",
            },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            {
              sign = {
                name = { ".*" },
                text = { ".*" },
                maxwidth = 2,
                colwidth = 1,
                auto = true,
                foldclosed = true,
              },
              click = "v:lua.ScSa",
            },
            {
              sign = {
                namespace = { "gitsigns" },
                maxwidth = 1,
                colwidth = 1,
                wrap = true,
                foldclosed = true,
              },
              click = "v:lua.ScSa",
            },
          },
        })
      end,
    },
  },
  opts = {
    -- INFO: Uncomment to use treeitter as fold provider, otherwise nvim lsp is used
    -- provider_selector = function(bufnr, filetype, buftype)
    --   return { "treesitter", "indent" }
    -- end,
    open_fold_hl_timeout = 400,
    close_fold_kinds_for_ft = { default = { "imports", "comment" } },
    preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        -- winhighlight = "Normal:Folded",
        winblend = 0,
      },
    },
  },
  config = function(_, opts)
    -- treesitter as a main provider instead
    -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = ("  󰁂 %d "):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      local rAlignAppndx =
        math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
      suffix = (" "):rep(rAlignAppndx) .. suffix
      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end

    local ufo_status, ufo = pcall(require, "ufo")
    if not ufo_status then
      return
    end

    local function goPreviousClosedAndPeek()
      ufo.goPreviousClosedFold()
      ufo.peekFoldedLinesUnderCursor()
    end

    local function goNextClosedAndPeek()
      ufo.goNextClosedFold()
      ufo.peekFoldedLinesUnderCursor()
    end

    vim.keymap.set("n", "zR", ufo.openAllFolds)
    vim.keymap.set("n", "zM", ufo.closeAllFolds)
    vim.keymap.set("n", "zi", goPreviousClosedAndPeek)
    vim.keymap.set("n", "zn", goNextClosedAndPeek)

    opts["fold_virt_text_handler"] = handler
    ufo.setup(opts)

    vim.cmd([[
      " hi Folded guibg=#2e3440 guifg=#81a1c1
      hi Folded guibg=NONE
    ]])
  end,
}
