describe("mona.ripgrep.args.factory", function()
  local factory = require("mona.ripgrep.args.factory")

  it("should return ripgrep options", function()
    local expected_args = {
      "--case-sensitive",
      "--trim",
      "--vimgrep",
      "--with-filename",
      "--word-regexp",
      "--glob",
      "*.ex",
      "--replace",
      "$1",
      "--regexp",
      "defmodule ([a-zA-Z0-9.]*) do$",
      "mona_test_umbrella_project",
    }

    local args = factory.default({
      directory = "mona_test_umbrella_project",
      glob = "*.ex",
      replace = "$1",
      regexp = "defmodule ([a-zA-Z0-9.]*) do$",
    })

    assert.same(expected_args, args)
  end)
end)
