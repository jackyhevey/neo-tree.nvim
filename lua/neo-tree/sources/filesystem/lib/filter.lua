-- This file holds all code for the search function.

local Input = require("nui.input")
local fs = require("neo-tree.sources.filesystem")
local popups = require("neo-tree.ui.popups")
local renderer = require("neo-tree.ui.renderer")
local utils = require("neo-tree.utils")
local log = require("neo-tree.log")
local manager = require("neo-tree.sources.manager")
local compat = require("neo-tree.utils._compat")
local common_filter = require("neo-tree.sources.common.filters")

local M = {}

---@param state neotree.sources.filesystem.State
---@param search_as_you_type boolean?
---@param fuzzy_finder_mode "directory"|boolean?
---@param use_fzy boolean?
---@param keep_filter_on_submit boolean?
M.show_filter = function(
  state,
  search_as_you_type,
  fuzzy_finder_mode,
  use_fzy,
  keep_filter_on_submit
)
  local popup_options
  local winid = vim.api.nvim_get_current_win()
  local height = vim.api.nvim_win_get_height(winid)
  local scroll_padding = 3
  local popup_msg = "Search:"

  if search_as_you_type then
    if fuzzy_finder_mode == "directory" then
      popup_msg = "Filter Directories:"
    else
      popup_msg = "Filter:"
    end
  end
  if state.config.title then
    popup_msg = state.config.title
  end
  if state.current_position == "float" then
    scroll_padding = 0
    local width = vim.fn.winwidth(winid)
    local row = height - 2
    vim.api.nvim_win_set_height(winid, row)
    popup_options = popups.popup_options(popup_msg, width, {
      relative = "win",
      winid = winid,
      position = {
        row = row,
        col = 0,
      },
      size = width,
    })
  else
    local width = vim.fn.winwidth(0) - 2
    local row = height - 3
    popup_options = popups.popup_options(popup_msg, width, {
      relative = "win",
      winid = winid,
      position = {
        row = row,
        col = 0,
      },
      size = width,
    })
  end

  ---@type neotree.Config.SortFunction
  local sort_by_score = function(a, b)
    -- `state.fzy_sort_result_scores` should be defined in
    -- `sources.filesystem.lib.filter_external.fzy_sort_files`
    local result_scores = state.fzy_sort_result_scores or { foo = 0, baz = 0 }
    local a_score = result_scores[a.path]
    local b_score = result_scores[b.path]
    if a_score == nil or b_score == nil then
      log.debug(
        string.format([[Fzy: failed to compare %s: %s, %s: %s]], a.path, a_score, b.path, b_score)
      )
      local config = require("neo-tree").config
      if config.sort_function ~= nil then
        return config.sort_function(a, b)
      end
      return nil
    end
    return a_score > b_score
  end

  local select_first_file = function()
    local is_file = function(node)
      return node.type == "file"
    end
    local files = renderer.select_nodes(state.tree, is_file, 1)
    if #files > 0 then
      renderer.focus_node(state, files[1]:get_id(), true)
    end
  end

  local has_pre_search_folders = utils.truthy(state.open_folders_before_search)
  if not has_pre_search_folders then
    log.trace("No search or pre-search folders, recording pre-search folders now")
    ---@type table|nil
    state.open_folders_before_search = renderer.get_expanded_nodes(state.tree)
  end

  local waiting_for_default_value = utils.truthy(state.search_pattern)
  local input = Input(popup_options, {
    prompt = " ",
    default_value = state.search_pattern,
    on_submit = function(value)
      if value == "" then
        fs.reset_search(state)
      else
        if search_as_you_type and fuzzy_finder_mode and not keep_filter_on_submit then
          fs.reset_search(state, true, true)
          return
        end
        state.search_pattern = value
        manager.refresh("filesystem", function()
          -- focus first file
          local nodes = renderer.get_all_visible_nodes(state.tree)
          for _, node in ipairs(nodes) do
            if node.type == "file" then
              renderer.focus_node(state, node:get_id(), false)
              break
            end
          end
        end)
      end
    end,
    --this can be bad in a deep folder structure
    on_change = function(value)
      if not search_as_you_type then
        return
      end
      -- apparently when a default value is set, on_change fires for every character
      if waiting_for_default_value then
        if #value < #state.search_pattern then
          return
        else
          waiting_for_default_value = false
        end
      end
      if value == state.search_pattern then
        return
      elseif value == nil then
        return
      elseif value == "" then
        if state.search_pattern == nil then
          return
        end
        log.trace("Resetting search in on_change")
        local original_open_folders = nil
        if type(state.open_folders_before_search) == "table" then
          original_open_folders = vim.deepcopy(state.open_folders_before_search, compat.noref())
        end
        fs.reset_search(state)
        state.open_folders_before_search = original_open_folders
      else
        log.trace("Setting search in on_change to: " .. value)
        state.search_pattern = value
        state.fuzzy_finder_mode = fuzzy_finder_mode
        if use_fzy then
          state.sort_function_override = sort_by_score
          state.use_fzy = true
        end
        ---@type function|nil
        local callback = select_first_file
        if fuzzy_finder_mode == "directory" then
          callback = nil
        end

        local len = #value
        local delay = 500
        if len > 3 then
          delay = 100
        elseif len > 2 then
          delay = 200
        elseif len > 1 then
          delay = 400
        end

        utils.debounce("filesystem_filter", function()
          fs._navigate_internal(state, nil, nil, callback)
        end, delay, utils.debounce_strategy.CALL_LAST_ONLY)
      end
    end,
  })

  input:mount()

  local restore_height = vim.schedule_wrap(function()
    if vim.api.nvim_win_is_valid(winid) then
      vim.api.nvim_win_set_height(winid, height)
    end
  end)
  ---@class neotree.sources.filesystem.FuzzyFinder.BuiltinCommands : neotree.FuzzyFinder.BuiltinCommands
  local cmds
  cmds = {
    move_cursor_down = function(_state, _scroll_padding)
      renderer.focus_node(_state, nil, true, 1, _scroll_padding)
    end,

    move_cursor_up = function(_state, _scroll_padding)
      renderer.focus_node(_state, nil, true, -1, _scroll_padding)
      vim.cmd("redraw!")
    end,

    close = function(_state, _scroll_padding)
      vim.cmd("stopinsert")
      input:unmount()
      -- If this was closed due to submit, that function will handle the reset_search
      vim.defer_fn(function()
        if
          fuzzy_finder_mode
          and utils.truthy(state.search_pattern)
          and not keep_filter_on_submit
        then
          fs.reset_search(state, true)
        end
      end, 100)
      restore_height()
    end,
    close_keep_filter = function(_state, _scroll_padding)
      log.info("Persisting the search filter")
      keep_filter_on_submit = true
      cmds.close(_state, _scroll_padding)
    end,
    close_clear_filter = function(_state, _scroll_padding)
      log.info("Clearing the search filter")
      keep_filter_on_submit = false
      cmds.close(_state, _scroll_padding)
    end,
  }

  common_filter.setup_hooks(input, cmds, state, scroll_padding)

  if not fuzzy_finder_mode then
    return
  end

  common_filter.setup_mappings(input, cmds, state, scroll_padding)
end

return M
