describe("mona.ripgrep.results.elixir", function()
  local elixir = require("mona.ripgrep.results.elixir")

  describe("module", function()
    it("should return parsed ripgrep output", function()
      local ripgrep_output =
        "mona_test_project/lib/mona_test_project.ex:1:1:MonaTestProject"

      local expected_result = {
        path = "mona_test_project/lib/mona_test_project.ex",
        line_number = 1,
        column_number = 1,
        module_name = "MonaTestProject",
      }

      local result = elixir.module(ripgrep_output)

      assert.same(expected_result, result)
    end)

    it(
      "should not return parsed ripgrep output if output is nil or empty",
      function()
        for _, ripgrep_output in ipairs({ nil, "" }) do
          local result = elixir.module(ripgrep_output)

          assert.truthy(result)
        end
      end
    )
  end)
end)
