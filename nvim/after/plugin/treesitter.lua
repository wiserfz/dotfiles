local parsers = require("nvim-treesitter.parsers")
parsers.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = { "src/parser.c" },
  },
  filetype = "gotmpl",
  used_by = {
    "gotmpl",
    "gohtmltmpl",
    "gotexttmpl",
    "goyamltmpl",
    -- "yaml",
    -- "ctmpl",
  },
}
