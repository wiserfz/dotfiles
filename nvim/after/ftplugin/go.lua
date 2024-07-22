vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.formatoptions:append({ c = true, r = true, o = true, q = true })

vim.cmd([[
  hi link @my.keyword.coroutine.go PreProc
  hi link @my.keyword.import PreProc
  hi link @my.keyword.function.go @keyword.return
  hi link @my.keyword.return.go @keyword.return
  hi @my.keyword.conditional.go guifg=#E85827
  hi link @my.keyword.repeat.go @my.keyword.conditional.go
  hi @my.keyword.go guifg=#bc0264
  hi link @my.keyword.type.go @my.keyword.go
]])
