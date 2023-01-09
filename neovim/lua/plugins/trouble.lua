local status, trouble = pcall(require, "trouble")

if not status then
  return
end

trouble.setup({
  position = "right",
  width = 75,
  padding = true,
  auto_preview = false,
})
