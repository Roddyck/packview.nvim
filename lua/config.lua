---@class packview.config
local M = {}

---@class packview.options
---@field window packview.options.window
---@field always_force_del boolean Always pass `force=true` to |vim.pack.del()| when deleting a package
M.options = {
  ---@class packview.options.window
  ---@field width number Percentage of screen width for floating window as a fraction of total width
  ---@field height number Percentage of screen height for floating window as a fraction of total height
  ---@field border string|string[] Border style for floating window (same as passed to |nvim_open_win()|)
  window = {
    width = 0.8,
    height = 0.8,
    border = "rounded",
    title = "Packview",
    title_pos = "center",
  },

  always_force_del = false,
}

---@param opts packview.options?
M.extend = function(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
