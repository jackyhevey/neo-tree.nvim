describe("manager state", function()
  it("can be retrieved at startup", function()
    local fs_state = require("neo-tree.sources.manager").get_state("filesystem")
    local buffers_state = require("neo-tree.sources.manager").get_state("buffers")
    assert.are_equal(type(fs_state), "table")
    assert.are_equal(type(buffers_state), "table")
  end)
end)
