local M = {}

function M.modules(directory, tests)
  local factory = require("mona.ripgrep.args.factory")

  local glob = tests and "*_test.exs" or "*.ex"

  local regexp =
    string.format("defmodule ([a-zA-Z0-9.]*%s) do$", tests and "Test" or "")

  return factory.default({
    directory = directory,
    glob = glob,
    replace = "$1",
    regexp = regexp,
  })
end

return M
