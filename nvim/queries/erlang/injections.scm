; extends

; highlight embedded markdown docs in erlang
forms_only: (wild_attribute
  name: (attr_name
    name: (atom) @doc_atom
    (#any-of? @doc_atom "moduledoc" "doc"))
  value: (string) @injection.content
  ; remove the string/backticks at the beginning/end of the string
  (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "markdown")) @erlang_embedded_markdown
