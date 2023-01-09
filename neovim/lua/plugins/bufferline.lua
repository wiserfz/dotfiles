local status, bufferline = pcall(require, "bufferline")

if not status then
  return
end

bufferline.setup({
  options = {
    separator_style = "thin",
    -- hover events
    hover = {
      enabled = true,
      delay = 100,
      reveal = { "close" },
    },
    -- underline indicator
    indicator = {
      style = "underline",
    },
    -- sidebar offset
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true, -- use a "true" to enable the default, or set your own character
      },
    },
    -- lsp indicators
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(_, level, _, _)
      local icon = level:match("error") and " " or " "
      return " " .. icon
    end,
  },
})
