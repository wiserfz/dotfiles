local status, save = pcall(require, "auto-save")

if not status then
  return
end

save.setup()
