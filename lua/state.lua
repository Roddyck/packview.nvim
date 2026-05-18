local M = {}

M.plugins = {}

M.remove_from_state = function(self, plugin_name)
  local idx_to_remove = nil

  for i, plugin in ipairs(M.plugins) do
    if plugin.spec.name == plugin_name then
      idx_to_remove = i
      break
    end
  end

  table.remove(self.plugins, idx_to_remove)
end

return M
