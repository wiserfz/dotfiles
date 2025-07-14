; extends

; vim:ft=query
; If the key is equal to "sql", and the value is a block scalar, then set the language to "sql"
(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @injection.language
      (#eq? @injection.language "sql")))
  value: (block_node
    (block_scalar) @injection.content
    (#offset! @injection.content 0 1 0 0)))

; .gitlab-ci.yml
(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_name
      (#eq? @_name "coverage")))
  value: (flow_node
    (single_quote_scalar) @injection.content
    (#set! injection.language "regex")
    (#offset! @injection.content 0 1 0 -2)))

; only for $CI_COMMIT_TAG variable
(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_name
      (#eq? @_name "rules")))
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_mapping
            (block_mapping_pair
              key: (flow_node
                (plain_scalar
                  (string_scalar)))
              value: (flow_node
                (plain_scalar
                  (string_scalar) @injection.content
                  (#lua-match? @injection.content "^%$.*=~.*/$")
                  ; (#gsub! @regex.value "^.*%s=~%s/(.*)/$" "%1")
                  (#offset! @injection.content 0 19 0 -1)
                  (#set! injection.language "regex"))))))))))

; vector vrl embedded in Yaml
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
    ]))

(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_key_field
      (#eq? @_key_field "key_field")))
  value: (flow_node
    (single_quote_scalar) @injection.content
    (#match? @injection.content "^'[.%].+'$")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "vrl")))

(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_key_field
      (#eq? @_key_field "key_field")))
  value: (flow_node
    (double_quote_scalar) @injection.content
    (#match? @injection.content "^\"[.%].+\"$")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "vrl")))

; inject bash environment variables
(block_mapping_pair
  key: (_)
  value: (flow_node
    (single_quote_scalar) @injection.content
    (#match? @injection.content "^'.*\\\$\\\{?.+\\\}?.*'$")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "bash")))

(block_mapping_pair
  key: (_)
  value: (flow_node
    (double_quote_scalar) @injection.content
    (#match? @injection.content "^\".*\\\$\\\{?.+\\\}?.*\"$")
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "bash")))

(block_mapping_pair
  key: (_)
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content
      (#match? @injection.content "^.*\\\$\\\{?.+\\\}?.*$")
      (#set! injection.language "bash"))))

; inject json for message field
(block_mapping_pair
  key: (flow_node
    (plain_scalar
      (string_scalar) @_log_fields
      (#eq? @_log_fields "log_fields")))
  value: (block_node
    (block_mapping
      (block_mapping_pair
        key: (flow_node
          (plain_scalar
            (string_scalar) @_message_field
            (#eq? @_message_field "message")))
        value: (block_node
          (block_scalar) @injection.content)
        (#match? @injection.content "^\|-[ \n]*\\\{.+\\\}$")
        (#offset! @injection.content 0 2 0 0)
        (#set! injection.language "json")))))
