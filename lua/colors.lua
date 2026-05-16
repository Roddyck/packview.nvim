local M = {}

M.colors = {
  Line = "NormalFloat",
  Header = { bold = true },
  Total = {
    bold = true,
    bg = vim.api.nvim_get_hl(0, { name = "WinBar" }).bg,
  },
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
