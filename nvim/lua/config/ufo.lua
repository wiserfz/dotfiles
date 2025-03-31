local ufo = require("ufo")
local wk = require("which-key")

--@param virtText table @The virtual text
--@param lnum number @The line number
--@param endLnum number @The end line number
--@param width number @The width of the window
--@param truncate function @The function to truncate the virtual text
--@return table @The new virtual text
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

local function goPreviousClosedAndPeek()
  ufo.goPreviousClosedFold()
  ufo.peekFoldedLinesUnderCursor()
end

local function goNextClosedAndPeek()
  ufo.goNextClosedFold()
  ufo.peekFoldedLinesUnderCursor()
end

local M = {}

function M.setup()
  local opts = {
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
    fold_virt_text_handler = handler,
  }

  ufo.setup(opts)

  wk.add({
    { "<leader>z", group = "Fold" },

    {
      "<leader>zR",
      ufo.openAllFolds,
      desc = "Open all folds",
    },
    {
      "<leader>zM",
      ufo.closeAllFolds,
      desc = "Close all folds",
    },
    {
      "<leader>zr",
      ufo.openFoldsExceptKinds,
      desc = "Open folds except specified kinds",
    },
    {
      "<leader>zm",
      ufo.closeFoldsWith,
      desc = "Close the folds with a higher level",
    },
    {
      "<leader>zk",
      goPreviousClosedAndPeek,
      desc = "Preview previous fold",
    },
    {
      "<leader>zj",
      goNextClosedAndPeek,
      desc = "Preview next fold",
    },
  })

  vim.cmd([[
    " hi Folded guibg=#2e3440 guifg=#81a1c1
    hi Folded guibg=NONE
    hi FoldColumn guifg=gray guibg=#232526
  ]])
end

return M
