local M = {}

local mt = {
  __call = function(_, entry)
    local notify =
      require("mona.notify").for_telescope("elixir.modules.entry_maker")()

    local module = require("mona.ripgrep.results.elixir").module(entry)

    if
      not module
      or not module.column_number
      or not module.module_name
      or not module.line_number
      or not module.path
    then
      notify.warn("table value is nil or empty, table: " .. vim.inspect(module))
      return false
    end

    return {
      col = module.column_number,
      display = module.module_name,
      lnum = module.line_number,
      ordinal = module.module_name,
      path = module.path,
      value = entry,
    }
  end,
}

return setmetatable(M, mt)
