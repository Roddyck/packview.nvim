local M = {}

---@param opts packview.options.window
M.create_floating_win = function(opts)
  local width = math.floor(vim.o.columns * opts.width)
  local height = math.floor(vim.o.lines * opts.height)

  local buf = vim.api.nvim_create_buf(false, true)

  ---@type vim.api.keyset.win_config
  local win_config = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = opts.border,
    title = opts.title,
    title_pos = opts.title_pos,
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

---@param buf integer
---@param plugins vim.pack.PlugData[]
M.set_buf_contents = function(buf, plugins)
  local lines = {}

  table.insert(lines, string.format("Total: %d plugins", #plugins))
  table.insert(lines, "")

  local name_width = 80
  local version_width = 20
  local active_width = 20
  local header = string.format("%-80s %-20s %-20s", "Name", "Version", "Active")
  table.insert(lines, header)

  for _, plugin in ipairs(plugins) do
    local name = plugin.spec.name
    local version = plugin.spec.version or plugin.branches[1]
    local active = plugin.active

    local line = string.format("%-80s %-20s %-20s", name, version, active)
    table.insert(lines, line)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local ns_id = vim.api.nvim_create_namespace("packview")

  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
    line_hl_group = "PackviewTotal",
    end_row = 0,
  })

  vim.api.nvim_buf_set_extmark(buf, ns_id, 2, 0, {
    line_hl_group = "PackviewHeader",
    end_row = 2,
  })

  for i = 3, #lines - 1 do
    vim.api.nvim_buf_set_extmark(buf, ns_id, i, 0, {
      line_hl_group = "PackviewLine",
      end_row = i,
    })

    vim.api.nvim_buf_set_extmark(buf, ns_id, i, 0, {
      hl_group = "PackviewName",
      end_col = name_width,
    })

    vim.api.nvim_buf_set_extmark(buf, ns_id, i, name_width, {
      hl_group = "PackviewVersion",
      end_col = name_width + version_width,
    })

    vim.api.nvim_buf_set_extmark(buf, ns_id, i, name_width + version_width, {
      hl_group = "PackviewActive",
      end_col = name_width + version_width + active_width,
    })
  end
end

M.get_plugin_name = function(line)
  local name = line:match("^(%S+)")
  return name
end

return M
