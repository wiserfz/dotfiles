; extends

(pair
  (bare_key) @_source
  (#any-of? @_source "source" "condition")
  (string) @injection.content
  (#match? @injection.content "^'''\n")
  (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "vrl"))

(pair
  (bare_key) @_source
  (#any-of? @_source "source" "condition")
  (string) @injection.content
  (#match? @injection.content "^[\"']")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "vrl"))

(table
  (dotted_key
    (_)
    (bare_key) @_route
    (#eq? @_route "route"))
  (pair
    (_)
    (string) @injection.content
    (#match? @injection.content "^'''\n")
    (#offset! @injection.content 0 3 0 -3)
    (#set! injection.language "vrl")))

(table
  (dotted_key
    (_)
    (bare_key) @_route
    (#eq? @_route "route"))
  (pair
    (_)
    (string) @injection.content
    (#match? @injection.content "^[\"']")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "vrl")))

(pair
  (bare_key) @_key_field
  (#eq? @_key_field "key_field")
  (string) @injection.content
  (#match? @injection.content "^\"[.%].+\"$")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "vrl"))

; inject bash environment variables
(pair
  (_)
  (string) @injection.content
  (#match? @injection.content "^\"\\\$\\\{?.+\\\}?\"$")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "bash"))

; inject json for message field
(table
  (dotted_key
    (_)
    (bare_key) @_log_fields
    (#eq? @_log_fields "log_fields"))
  (pair
    (bare_key) @_message_field
    (#eq? @_message_field "message")
    (string) @injection.content
    (#match? @injection.content "^'''[ \n]*\\\{.+\\\}[ \n]*'''$")
    (#offset! @injection.content 0 3 0 -3)
    (#set! injection.language "json")))
