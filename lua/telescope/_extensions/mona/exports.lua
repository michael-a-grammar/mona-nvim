local M = {}

local mt = {
  __call = function(_)
    local config = require("telescope._extensions.mona.config")

    local included_pickers_picker =
      require("telescope._extensions.mona.included_pickers.picker")

    local elixir_modules_factory =
      require("telescope._extensions.mona.elixir.modules.factory")

    local pickers = {
      elixir_project_modules = elixir_modules_factory.project,
      elixir_application_modules = elixir_modules_factory.application,
      elixir_buffer_directory_modules = elixir_modules_factory.buffer_directory,
      elixir_project_tests = elixir_modules_factory.tests.project,
      elixir_application_tests = elixir_modules_factory.tests.application,
      elixir_buffer_directory_tests = elixir_modules_factory.tests.buffer_directory,

      [config.included_pickers_name] = included_pickers_picker,
    }

    for picker_name, picker in pairs(pickers) do
      pickers[picker_name] = function(opts)
        opts = opts or {}

        opts.picker_name = picker_name

        picker(opts)
      end
    end

    config.register_included_pickers(pickers)

    return pickers
  end,
}

return setmetatable(M, mt)
