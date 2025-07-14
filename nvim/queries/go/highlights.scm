; extends

("go" @my.keyword.coroutine
  (#set! "priority" 126))

("func" @my.keyword.function
  (#set! "priority" 126))

("return" @my.keyword.return
  (#set! "priority" 126))

([
  "else"
  "case"
  "switch"
  "if"
] @my.keyword.conditional
  (#set! "priority" 126))

("for" @my.keyword.repeat
  (#set! "priority" 126))

([
  "break"
  "const"
  "continue"
  "default"
  "defer"
  "goto"
  "range"
  "select"
  "var"
  "fallthrough"
] @my.keyword
  (#set! "priority" 126))

([
  "type"
  "struct"
  "interface"
] @my.keyword.type
  (#set! "priority" 126))

([
  "import"
  "package"
] @my.keyword.import
  (#set! "priority" 126))
