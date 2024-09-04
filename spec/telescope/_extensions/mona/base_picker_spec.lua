describe("telescope._extensions.mona.base_picker", function()
  local base_picker = require("telescope._extensions.mona.base_picker")

  it("should return the telescope pickers, config and merged config", function()
    local pickers, config, merged_config = base_picker()

    assert.truthy(pickers)
    assert.truthy(config)
    assert.truthy(merged_config)
  end)
end)
