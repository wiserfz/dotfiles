; extends

; highlight sqlite commands in python
(call
  function: (attribute
    object: (identifier) @py_object
    attribute: (identifier) @py_function)
  (#match? @py_function "^execute")
  (#match? @py_object ".*(cur|conn)(ection)?$")
  arguments: (argument_list
    (string
      (string_content) @injection.content))
  (#set! injection.language "sql")) @python_highlight_sqlite

(call
  function: (attribute
    object: (identifier) @py_object
    attribute: (identifier) @py_function)
  (#eq? @py_object "shlex")
  (#eq? @py_function "split")
  arguments: (argument_list
    (string
      (string_content) @injection.content))
  (#set! injection.language "bash")) @python_highlight_shlex

((string_content) @injection.content
  (#match? @injection.content
    "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
  (#set! injection.language "sql"))
