describe("telescope._extensions.mona.utils", function()
  local utils = require("telescope._extensions.mona.utils")

  describe("string", function()
    describe("capitalise", function()
      it("should capitalise the first word of a string", function()
        local result = utils.string.capitalise("hello world")

        assert.same("Hello world", result)
      end)

      it("should capitalise a string containing a unicode character", function()
        local result = utils.string.capitalise("Hello  world")

        assert.same("Hello  world", result)
      end)

      it(
        "should not capitalise a string starting with a unicode character",
        function()
          local result = utils.string.capitalise(" hello world")

          assert.same(" hello world", result)
        end
      )
    end)
  end)
end)
