local M = {}

local mt = {
  __call = function(_, opts)
    opts.prompt_title = " " .. "mona"

    local pickers, config, merged_config =
      require("telescope._extensions.mona.base_picker")(opts)

    local attach_mappings =
      require("telescope._extensions.mona.included_pickers.attach_mappings")

    local finder = require("telescope._extensions.mona.included_pickers.finder")

    return pickers
      .new(merged_config, {
        attach_mappings = attach_mappings,
        finder = finder(merged_config),
        sorter = config.values.generic_sorter(merged_config),
      })
      :find()
  end,
}

return setmetatable(M, mt)
