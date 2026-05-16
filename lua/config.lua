---@class packview.config
local M = {}

---@class packview.options
---@field window packview.options.window
M.options = {
  ---@class packview.options.window
  ---@field width number Percentage of screen width for floating window as a fraction of total width
  ---@field height number Percentage of screen height for floating window as a fraction of total height
  ---@field border string|string[] Border style for floating window (same as passed to |nvim_open_win()|)
  ---@field title string Title for floating window
  ---@field title_pos string Position of title for floating window (same as passed to |nvim_open_win()|)
  window = {
    width = 0.8,
    height = 0.8,
    border = "rounded",
    title = "Packview",
    title_pos = "center",
  },
}

---@param opts packview.options?
M.extend = function(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
