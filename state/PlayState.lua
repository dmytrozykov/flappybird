-- PlayState.lua

---@class PlayState
---@field name string
---@field stateManager StateManager
local PlayState = {
  name = "PlayState"
}

---@param stateManager StateManager
---@return PlayState
function PlayState:new(stateManager)
  local state = {
    stateManager = stateManager
  }
  setmetatable(state, {__index = self})
  return state
end

return PlayState
