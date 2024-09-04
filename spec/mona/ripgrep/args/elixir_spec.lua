describe("mona.ripgrep.args.elixir", function()
  local elixir = require("mona.ripgrep.args.elixir")

  local directory = "mona_test_umbrella_project"

  describe("modules", function()
    it("should return ripgrep options to search for elixir modules", function()
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

      local args = elixir.modules(directory, false)

      assert.same(expected_args, args)
    end)

    it("should return ripgrep options to search for elixir tests", function()
      local expected_args = {
        "--case-sensitive",
        "--trim",
        "--vimgrep",
        "--with-filename",
        "--word-regexp",
        "--glob",
        "*_test.exs",
        "--replace",
        "$1",
        "--regexp",
        "defmodule ([a-zA-Z0-9.]*Test) do$",
        "mona_test_umbrella_project",
      }

      local args = elixir.modules(directory, true)

      assert.same(expected_args, args)
    end)
  end)
end)
