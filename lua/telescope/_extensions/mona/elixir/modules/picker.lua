local M = {}

local mt = {
  __call = function(_, opts)
    local pickers, config, merged_config =
      require("telescope._extensions.mona.base_picker")(opts)

    local finder = require("telescope._extensions.mona.elixir.modules.finder")

    return pickers
      .new(merged_config, {
        finder = finder(merged_config),
        previewer = config.values.grep_previewer(merged_config),
        sorter = config.values.file_sorter(merged_config),
      })
      :find()
  end,
}

return setmetatable(M, mt)
