local M = {}

local mt = {
  __call = function(_, _)
    local finders = require("telescope.finders")

    local config = require("telescope._extensions.mona.config")

    local entry_maker =
      require("telescope._extensions.mona.included_pickers.entry_maker")

    return finders.new_table({
      entry_maker = entry_maker,
      results = config.included_pickers,
    })
  end,
}

return setmetatable(M, mt)
