local colors = require("colors")
local packview = require("packview")

colors.setup_highlights()

vim.api.nvim_create_user_command("Pack", function()
  packview.open()
end, {})

vim.api.nvim_create_user_command("PackUpdate", function(args)
  if #args.fargs == 0 then
    vim.pack.update()
  else
    vim.pack.update(args.fargs)
  end
end, { nargs = "*" })

vim.api.nvim_create_user_command("PackDel", function(args)
  if #args.fargs == 0 then
    local plugins = vim.pack.get()
    local inactive_plugins = vim.tbl_filter(function(plugin)
      return not plugin.active
    end, plugins)

    vim.pack.del(vim.tbl_map(function(plugin)
      return plugin.spec.name
    end, inactive_plugins))

    for _, plugin in ipairs(inactive_plugins) do
      packview._remove_from_state(plugin.spec.name)
    end
  else
    vim.pack.del(args.fargs)

    for _, plugin_name in ipairs(args.fargs) do
      packview._remove_from_state(plugin_name)
    end
  end
end, { nargs = "*" })
