-- commenting with gc
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  lazy = false,
  config = function()
    local setup, comment = pcall(require, "Comment")
    if not setup then
      return
    end

    comment.setup()
  end,
}
