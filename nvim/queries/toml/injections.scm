;; extends
;; vim:ft=query

; (table
;   (dotted_key
;     (bare_key) @_transforms
;     (bare_key))
;   (pair
;     (bare_key) @_source
;     (string) @injection.content)
;   (#eq? @_transforms "transforms")
;   (#eq? @_source "source")
;   (#match? @injection.content "^'''\n")
;   (#offset! @injection.content 0 3 0 -3)
;   (#set! injection.language "vrl"))
;
; (table
;   (dotted_key
;     (dotted_key
;       (bare_key) @_transforms
;       (_))
;     (bare_key) @_condition)
;   (pair
;     (bare_key) @_source
;     (string) @injection.content)
;   (#eq? @_transforms "transforms")
;   (#eq? @_condition "condition")
;   (#eq? @_source "source")
;   (#match? @injection.content "^'''\n")
;   (#offset! @injection.content 0 3 0 -3)
;   (#set! injection.language "vrl"))
;
; (table_array_element
;   (dotted_key
;     (dotted_key (_))
;     (bare_key) @_conditions)
;   (pair
;     (bare_key) @_source
;     (string) @injection.content)
;   (#eq? @_conditions "conditions")
;   (#eq? @_source "source")
;   (#match? @injection.content "^'''\n")
;   (#offset! @injection.content 0 3 0 -3)
;   (#set! injection.language "vrl"))
;
; (table_array_element
;   (dotted_key
;     (dotted_key (_))
;     (bare_key) @_conditions)
;   (pair
;     (bare_key) @_source
;     (string) @injection.content)
;   (#eq? @_conditions "conditions")
;   (#eq? @_source "source")
;   (#match? @injection.content "^[\"']")
;   (#offset! @injection.content 0 1 0 -1)
;   (#set! injection.language "vrl"))

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
  (#match? @injection.content "^'")
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
  (#set! injection.language "vrl"))
)

(table
  (dotted_key
  (_)
  (bare_key) @_route
  (#eq? @_route "route"))
  (pair
  (_)
  (string) @injection.content
  (#match? @injection.content "^'")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "vrl"))
)
