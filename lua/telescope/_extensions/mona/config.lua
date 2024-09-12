local M = {}

local included_pickers_name = 'pickers'

_G._TelescopeMonaConfig = _G._TelescopeMonaConfig
  or {
    pickers = {
      [included_pickers_name] = {
        theme = 'dropdown',
      },
    },
  }

_G._TelescopeMonaPickers = _G._TelescopeMonaPickers or {}

M.values = _G._TelescopeMonaConfig
M.included_pickers = _G._TelescopeMonaPickers

M.included_pickers_name = included_pickers_name

local deep_extend_tables = function(table1, table2)
  return vim.tbl_deep_extend('force', table1, table2)
end

local extend_config_values = function(opts)
  if not opts then
    return
  end

  M.values = deep_extend_tables(M.values, opts)
end

local get_theme_config = function(
  picker_opts,
  default_picker_opts,
  extension_opts
)
  local theme

  for _, opts in ipairs({ extension_opts, default_picker_opts, picker_opts }) do
    if opts and opts.theme then
      theme = opts.theme
    end
  end

  if theme and M.values.theme then
    return require('telescope.themes')['get_' .. theme]()
  end

  return {}
end

M.setup = function(ext_config, config)
  extend_config_values(config)
  extend_config_values(ext_config)

  return M
end

M.merge = function(opts)
  local default_picker_opts = M.values.pickers[opts.picker_name] or {}

  local theme_config = get_theme_config(opts, default_picker_opts, M.values)

  local config = deep_extend_tables(
    deep_extend_tables(
      deep_extend_tables(M.values, default_picker_opts),
      theme_config
    ),
    opts
  )

  return config
end

M.register_included_pickers = function(pickers)
  for picker_name, picker in pairs(pickers) do
    if picker_name ~= M.included_pickers_name then
      table.insert(M.included_pickers, {
        picker_name,
        picker,
      })
    end
  end
end

return M
