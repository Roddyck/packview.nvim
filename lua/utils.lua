local config = require("config")

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

  local win_width = math.floor(vim.o.columns * config.options.window.width)
  local topbar = "[u] Update [U] Update all [d] Delete [X] Clean"
  local topbar_padding = string.rep(" ", math.floor((win_width - #topbar) / 2))

  table.insert(lines, string.format("%s%s", topbar_padding, topbar))
  table.insert(lines, "")

  table.insert(lines, string.format("Total: %d plugins", #plugins))
  table.insert(lines, "")

  local name_width = 40
  local version_width = 20

  local active_plugins = vim.tbl_filter(function(plugin)
    return plugin.active
  end, plugins)

  table.insert(lines, string.format("Active (%d)", #active_plugins))
  for _, plugin in ipairs(active_plugins) do
    local name = plugin.spec.name
    local version = plugin.spec.version or plugin.branches[1]

    local line = string.format("• %-40s %-20s", name, version)
    table.insert(lines, line)
  end

  local inactive_plugins = vim.tbl_filter(function(plugin)
    return not plugin.active
  end, plugins)

  if #inactive_plugins > 0 then
    table.insert(lines, "")
    table.insert(lines, string.format("Inactive (%d)", #inactive_plugins))
    for _, plugin in ipairs(inactive_plugins) do
      local name = plugin.spec.name
      local version = plugin.spec.version or plugin.branches[1]

      local line = string.format("• %-40s %-20s", name, version)
      table.insert(lines, line)
    end
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local ns_id = vim.api.nvim_create_namespace("packview")

  local set_topbar_extmarks = function(offset, len)
    vim.api.nvim_buf_set_extmark(buf, ns_id, 0, #topbar_padding + offset, {
      hl_group = "PackviewHelp",
      end_col = #topbar_padding + offset + 3,
    })
    vim.api.nvim_buf_set_extmark(buf, ns_id, 0, #topbar_padding + offset, {
      hl_group = "PackviewBut",
      end_col = #topbar_padding + offset + len,
    })
  end

  set_topbar_extmarks(0, 10)
  set_topbar_extmarks(11, 14)
  set_topbar_extmarks(26, 10)
  set_topbar_extmarks(37, 9)

  vim.api.nvim_buf_set_extmark(buf, ns_id, 2, 0, {
    line_hl_group = "PackviewTotal",
    end_row = 2,
  })

  vim.api.nvim_buf_set_extmark(buf, ns_id, 4, 0, {
    line_hl_group = "PackviewHeader",
    end_row = 4,
  })

  for i = 5, #active_plugins - 1 + 5 do
    vim.api.nvim_buf_set_extmark(buf, ns_id, i, 0, {
      line_hl_group = "PackviewLine",
      end_row = i,
    })

    vim.api.nvim_buf_set_extmark(buf, ns_id, i, 0, {
      hl_group = "PackviewName",
      end_col = name_width + 2,
    })

    vim.api.nvim_buf_set_extmark(buf, ns_id, i, name_width, {
      hl_group = "PackviewVersion",
      end_col = name_width + version_width + 2,
    })
  end

  if #inactive_plugins > 0 then
    vim.api.nvim_buf_set_extmark(buf, ns_id, #active_plugins + 5 + 1, 0, {
      line_hl_group = "PackviewHeader",
      end_row = #active_plugins + 5,
    })

    for i = #active_plugins + 1 + 5 + 1, #lines - 1 do
      vim.api.nvim_buf_set_extmark(buf, ns_id, i, 0, {
        line_hl_group = "PackviewLine",
        end_row = i,
      })

      vim.api.nvim_buf_set_extmark(buf, ns_id, i, 0, {
        hl_group = "PackviewName",
        end_col = name_width + 2,
      })

      vim.api.nvim_buf_set_extmark(buf, ns_id, i, name_width, {
        hl_group = "PackviewVersion",
        end_col = name_width + version_width + 2,
      })
    end
  end
end

M.get_plugin_name = function(line)
  local name = line:match("^(%S+)")
  return name
end

return M
