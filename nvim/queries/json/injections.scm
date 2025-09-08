; extends

(pair
  key: (_)
  value: (string
    (string_content) @injection.content
    (#match? @injection.content
      "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
    (#set! injection.language "sql")))

; jinja injections for json string value
(pair
  key: (_)
  value: (string
    (string_content) @injection.content
    (#lua-match? @injection.content "{[%%{].+[%%}]}")
    (#set! injection.language "jinja")))
