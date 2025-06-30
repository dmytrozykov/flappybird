-- MenuState.lua

local Colors = require("Colors")
local Button = require("Button")
local Font = require("Font")
local ScreenSpace = require("ScreenSpace")
local Sprite = require("Sprite")

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
  playButton.font = Font.upheaval.paragraph
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

local function drawTitle()
  love.graphics.setColor(Colors.text)
  love.graphics.setFont(Font.upheaval.title)

  local title = "Flappy Bird"
  local titleWidth = Font.upheaval.title:getWidth(title)
  local titleX, titleY = ScreenSpace.toScreen(0, -0.5)
  titleX = titleX - titleWidth / 2

  love.graphics.print(title, titleX, titleY)
end

local function drawBird()
  local image = Sprite.bird[1]
  image:setFilter("nearest", "nearest")


  local x, y = ScreenSpace.toScreen(0, -0.7)
  local scale = 10
  x = x - (image:getWidth() * scale) / 2
  y = y - (image:getHeight() * scale) / 2

  love.graphics.draw(image, x, y, 0, scale, scale)
end

function MenuState:draw()
  love.graphics.setBackgroundColor(Colors.background)

  drawBird()
  drawTitle()

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

