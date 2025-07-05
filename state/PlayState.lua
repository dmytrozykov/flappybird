-- PlayState.lua

local Colors = require("Colors")
local Bird = require("Bird")
local Pipe = require("Pipe")

---@class PlayState
---@field name string
---@field stateManager StateManager
---@field bird Bird
---@field pipe Pipe
local PlayState = {
  name = "PlayState"
}

function PlayState:reset()
  local width, height = love.graphics.getDimensions()
  self.bird = Bird:new({x = width / 2, y = height / 2})
  self.pipe = Pipe:new({x = width / 2, y = height / 2})
end

---@param stateManager StateManager
---@return PlayState
function PlayState:new(stateManager)
  ---@type PlayState
  local state = {
    stateManager = stateManager,
  }
  setmetatable(state, {__index = self})
  state:reset()
  return state
end

function PlayState:enter()
  self:reset()
end

function PlayState:draw()
  love.graphics.setBackgroundColor(Colors.background)

  self.bird:draw()
  self.pipe:draw()
end

---@param dt number 
function PlayState:update(dt)
  self.bird:update(dt)
  self.pipe:update(dt)
end

---@param key love.KeyConstant
function PlayState:keypressed(key)
  if key == "escape" then
    self.stateManager:switch("MenuState")
  end

  self.bird:keypressed(key)
end

return PlayState
