local parsers = require("nvim-treesitter.parsers").get_parser_configs()
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
