-- PlayState.lua

local Colors = require("Colors")
local Bird = require("Bird")

---@class PlayState
---@field name string
---@field stateManager StateManager
---@field bird Bird
local PlayState = {
  name = "PlayState"
}

---@param stateManager StateManager
---@return PlayState
function PlayState:new(stateManager)
  local width, height = love.graphics.getDimensions()
  local state = {
    stateManager = stateManager,
    bird = Bird:new({x = width / 2, y = height / 2})
  }
  setmetatable(state, {__index = self})
  return state
end

function PlayState:draw()
  love.graphics.setBackgroundColor(Colors.background)

  self.bird:draw()
end

---@param dt number 
function PlayState:update(dt)
  self.bird:update(dt)
end

---@param key love.KeyConstant
function PlayState:keypressed(key)
  if key == "escape" then
    self.stateManager:switch("MenuState")
  end
end

return PlayState
