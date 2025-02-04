vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.formatoptions:append({ c = true, r = true, o = true, q = true })

vim.cmd([[
  hi link @keyword.coroutine.go PreProc
  hi @keyword.function.go guifg=#81D8D0
  hi link @keyword.return.go @keyword.function.go
  hi @keyword.conditional.go guifg=#E85827
]])
