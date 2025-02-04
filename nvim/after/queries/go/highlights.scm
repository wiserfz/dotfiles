;; extends

("go" @keyword.coroutine
  (#set! "priority" 126))

("func" @keyword.function
  (#set! "priority" 126))

("return" @keyword.return
  (#set! "priority" 126))

([
  "else"
  "case"
  "switch"
  "if"
] @keyword.conditional
  (#set! "priority" 126))
