local plugin = {}

---@param cmd string[]
function plugin.build(cmd)
   return function(args)
      vim.notify(string.format("Building %s", args.name), vim.log.levels.INFO)
      vim.notify(vim.inspect(args))
      local sysobject = vim.system(cmd, { cwd = args.path }):wait()
      if sysobject.code ~= 0 then vim.notify(string.format("Failed building %s", args.name), vim.log.levels.ERROR) end
   end
end

return plugin
