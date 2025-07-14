; extends

(call_expression
  function: (field_expression
    field: (field_identifier) @panic.call
    (#match? @panic.call "(unwrap$|expect$)")
    (#set! "priority" 128)))

([
  "return"
  "yield"
] @my.keyword.return
  (#set! "priority" 128))
