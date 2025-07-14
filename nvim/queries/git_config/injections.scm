; extends

(variable
  (_)
  value: (string) @injection.content
  (#lua-match? @injection.content "^\"sed")
  (#offset! @injection.content 0 6 0 -2)
  (#set! injection.language "regex")) @gitconfig_embedded_sed
