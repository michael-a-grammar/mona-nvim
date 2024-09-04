local config = require("telescope._extensions.mona.config")
local exports = require("telescope._extensions.mona.exports")

return require("telescope").register_extension({
  exports = exports(),
  setup = config.setup,
})
