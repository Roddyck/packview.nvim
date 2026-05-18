local M = {}

M.colors = {
  Line = "NormalFloat",
  But = {
    fg = vim.api.nvim_get_hl(0, { name = "NormalFloat" }).fg,
    bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg,
  },
  Help = {
    fg = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg,
    bg = vim.api.nvim_get_hl(0, { name = "Visual" }).bg,
  },
  Header = { bold = true },
  Total = { bold = true },
  Name = "Directory",
  Version = "DiagnosticHint",
  Active = "Boolean",
}

M.setup_highlights = function()
  for hl_group, link in pairs(M.colors) do
    local hl = type(link) == "table" and link or { link = link }
    vim.api.nvim_set_hl(0, "Packview" .. hl_group, hl)
  end
end

return M
