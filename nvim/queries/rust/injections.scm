;; extends

; Inject SQL in rust but in rust macro has problem
; see: https://github.com/nvim-treesitter/nvim-treesitter/issues/3110
((string_content) @injection.content
  (#match? @injection.content
    "^(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
  (#set! injection.language "sql")) @rust_embedded_string_sql

; Inject json in rust
((string_content) @injection.content
  (#lua-match? @injection.content "^%s*{.*}%s*$")
  (#set! injection.language "json")) @rust_embedded_string_json
