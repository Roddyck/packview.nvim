local config = require("config")
local utils = require("utils")

local M = {}

local function setup_keymaps(win, buf)
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf })

  vim.keymap.set("n", "u", function()
    local plug = utils.get_plugin_name(vim.api.nvim_get_current_line())
    if not plug then
      vim.notify("No plugin found in current line", vim.log.levels.ERROR)
      return
    end

    vim.pack.update({ plug })
  end, { buffer = buf })

  vim.keymap.set("n", "U", function()
    vim.pack.update()
  end, { buffer = buf })

  vim.keymap.set("n", "d", function()
    local plug = utils.get_plugin_name(vim.api.nvim_get_current_line())
    if not plug then
      vim.notify("No plugin found in current line", vim.log.levels.ERROR)
      return
    end

    local active = vim.pack.get({ plug })[1].active
    if active then
      vim.notify("Plugin is active, remove from config first", vim.log.levels.ERROR)
      return
    end

    vim.pack.del({ plug })
  end, { buffer = buf })

  vim.keymap.set("n", "X", function()
    local plugins_info = vim.pack.get()

    local inactive_plugins = vim.tbl_filter(function(plugin)
      return not plugin.active
    end, plugins_info)

    vim.pack.del(vim.tbl_map(function(plugin)
      return plugin.spec.name
    end, inactive_plugins))
  end, { buffer = buf })
end

M.open = function()
  local float = utils.create_floating_win(config.options.window)
  local plugins = vim.pack.get()
  utils.set_buf_contents(float.buf, plugins)
  setup_keymaps(float.win, float.buf)

  vim.api.nvim_set_option_value("modifiable", false, { buf = float.buf })
  vim.api.nvim_set_option_value("readonly", true, { buf = float.buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = float.buf })
end

---@param opts packview.options?
M.setup = function(opts)
  config.extend(opts)
end

return M
