-- MenuState.lua

local Colors = require("Colors")
local Button = require("Button")

---@class MenuState
---@field stateManger StateManager
---@field playButton Button
local MenuState = {
  name = "Menu"
}

---@param stateManager StateManager
---@return MenuState
function MenuState:new(stateManager)
  local playButton = Button:new(0, 0, 100, 50, "Play")
  playButton.font = love.graphics.newFont(32)
  playButton.onClick = function()
    print("Play pressed")
  end

  local state = {
    stateManager = stateManager,
    playButton = playButton,
  }
  setmetatable(state, {__index = self})
  return state
end

function MenuState:draw()
  love.graphics.setBackgroundColor(Colors.background)

  self.playButton:draw()
end

---@param dt number
function MenuState:update(dt) 
  self.playButton:update()
end

---@param key love.KeyConstant
function MenuState:keypressed(key)
  if key == "escape" then
    os.exit()
  end
end

---@param x number
---@param y number
---@param button number 
function MenuState:mousepressed(x, y, button)
  self.playButton:mousepressed(button)
end

---@param x number
---@param y number
---@param button number 
function MenuState:mousereleased(x, y, button)
  self.playButton:mousereleased(button)
end

return MenuState

