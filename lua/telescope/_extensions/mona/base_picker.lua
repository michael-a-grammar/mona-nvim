local M = {}

local mt = {
  __call = function(_, opts)
    opts = opts or {}

    local pickers = require("telescope.pickers")
    local config = require("telescope._extensions.mona.config")

    local merged_config = config.merge(opts)

    return pickers, config, merged_config
  end,
}

return setmetatable(M, mt)
