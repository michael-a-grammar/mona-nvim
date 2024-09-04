local M = {}

local mt = {
  __call = function(_, opts)
    if not opts then
      return false
    end

    local async_oneshot_finder =
      require("telescope.finders.async_oneshot_finder")

    local entry_maker =
      require("telescope._extensions.mona.elixir.modules.entry_maker")

    return async_oneshot_finder({
      entry_maker = entry_maker,

      fn_command = function()
        return {
          args = opts.vimgrep_arguments,
          command = "rg",
        }
      end,
    })
  end,
}

return setmetatable(M, mt)
