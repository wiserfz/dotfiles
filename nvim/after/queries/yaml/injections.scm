;; extends
;; vim:ft=query

;; If the key is equal to "sql", and the value is a block scalar, then set the language to "sql"
(block_mapping_pair
  key: (flow_node
    (plain_scalar (string_scalar) @injection.language
      (#eq? @injection.language "sql")))
  value: (block_node (block_scalar) @injection.content
    (#offset! @injection.content 0 1 0 0)))

;; .gitlab-ci.yml
(block_mapping_pair
    key: (flow_node
      (plain_scalar
        (string_scalar) @_name
        (#eq? @_name "coverage")
        ))
    value: (flow_node
      (single_quote_scalar) @injection.content
      (#set! injection.language "regex")
      (#offset! @injection.content 0 1 0 -2)))

;; vector vrl embedded in Yaml
(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_source
      (#any-of? @_source "source" "condition")))
  value: (block_node
    (block_scalar) @injection.content
    (#match? @injection.content "^[\\|][-+1-9]\n.*$")
    (#offset! @injection.content 0 2 0 0)
    (#set! injection.language "vrl")))

(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_source
      (#any-of? @_source "source" "condition")))
  value: (block_node
    (block_scalar) @injection.content
    (#match? @injection.content "^[\\|][-+][1-9]\n.*$")
    (#offset! @injection.content 0 3 0 0)
    (#set! injection.language "vrl")))

(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_source
      (#any-of? @_source "source" "condition")))
  value: (block_node
    (block_scalar) @injection.content
    (#match? @injection.content "^[\\|]\n.*$")
    (#offset! @injection.content 0 1 0 0)
    (#set! injection.language "vrl")))

(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_source
      (#eq? @_source "condition")))
  value: (flow_node
    [
      (plain_scalar
        (string_scalar) @injection.content
        (#offset! @injection.content 0 0 0 0)
        (#set! injection.language "vrl"))

        ((single_quote_scalar) @injection.content
        (#offset! @injection.content 0 1 0 -1)
        (#set! injection.language "vrl"))
    ]
  )
)
