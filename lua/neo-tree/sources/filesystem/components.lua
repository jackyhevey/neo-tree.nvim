-- This file contains the built-in components. Each componment is a function
-- that takes the following arguments:
--      config: A table containing the configuration provided by the user
--              when declaring this component in their renderer config.
--      node:   A NuiNode object for the currently focused node.
--      state:  The current state of the source providing the items.
--
-- The function should return either a table, or a list of tables, each of which
-- contains the following keys:
--    text:      The text to display for this item.
--    highlight: The highlight group to apply to this text.

local highlights = require("neo-tree.ui.highlights")
local common = require("neo-tree.sources.common.components")

---@alias neotree.Component.Filesystem._Key
---|"current_filter"

---@class neotree.Component.Filesystem
---@field [1] neotree.Component.Filesystem._Key|neotree.Component.Common._Key

---@type table<neotree.Component.Filesystem._Key, neotree.Renderer>
local M = {}

---@class (exact) neotree.Component.Filesystem.CurrentFilter : neotree.Component.Common.CurrentFilter

---@param config neotree.Component.Filesystem.CurrentFilter
M.current_filter = function(config, node, state)
  local filter = node.search_pattern or ""
  if filter == "" then
    return {}
  end
  return {
    {
      text = "Find",
      highlight = highlights.DIM_TEXT,
    },
    {
      text = string.format('"%s"', filter),
      highlight = config.highlight or highlights.FILTER_TERM,
    },
    {
      text = "in",
      highlight = highlights.DIM_TEXT,
    },
  }
end

return vim.tbl_deep_extend("force", common, M)
