vim.cmd([[
  hi @lsp.type.typeParameter.rust guifg=#F9DC24
  hi link @lsp.typemod.keyword.async.rust PreProc
  hi link @panic.call.rust DiagnosticError
  hi link @my.keyword.return.rust @keyword.return
  hi link @keyword.function.rust @my.keyword.return.rust
]])
