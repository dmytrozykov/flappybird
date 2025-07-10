-- LostState.lua

local Colors = require("Colors")
local Button = require("Button")
local Font = require("Font")
local ScreenSpace = require("ScreenSpace")

---@class LostState
---@field stateManger StateManager
---@field tryAgainButton Button
---@field mainMenuButton Button
---@field name string
local LostState = {
  name = "LostState"
}

---@param stateManager StateManager
---@return LostState
function LostState:new(stateManager)
  local state = {
    stateManager = stateManager,
  }

  local tryAgainButton = Button:new(0, 0, 200, 50, "Try Again")
  tryAgainButton.font = Font.upheaval.paragraph
  tryAgainButton.onClick = function()
    state.stateManager:switch("PlayState")
  end
  state.tryAgainButton = tryAgainButton

  local mainMenuButton = Button:new(0, 0.2, 200, 50, "Main Menu")
  mainMenuButton.font = Font.upheaval.paragraph
  mainMenuButton.onClick = function()
    state.stateManager:switch("MenuState")
  end
  state.mainMenuButton = mainMenuButton

  setmetatable(state, {__index = self})
  return state
end

local function drawMessage()
    local text = "You Lost"
    local font = Font.upheaval.title
    local shadowOffset = 5
    local width = font:getWidth(text)
    local x, y = ScreenSpace.toScreen(0, -0.3)
    x = x - width / 2

    love.graphics.setFont(font)

     -- Draw shadow
    love.graphics.setColor(Colors.shadow)
    love.graphics.print(text, x + shadowOffset, y + shadowOffset)

    -- Draw text
    love.graphics.setColor(Colors.text)
    love.graphics.print(text, x, y)
end

function LostState:draw()
  love.graphics.setBackgroundColor(Colors.background)

  drawMessage()
  self.tryAgainButton:draw()
  self.mainMenuButton:draw()
end

function LostState:update()
  self.tryAgainButton:update()
  self.mainMenuButton:update()
end

---@param button number 
function LostState:mousepressed(_, _, button)
  self.tryAgainButton:mousepressed(button)
  self.mainMenuButton:mousepressed(button)
end

---@param button number 
function LostState:mousereleased(_, _, button)
  self.tryAgainButton:mousereleased(button)
  self.mainMenuButton:mousereleased(button)
end

return LostState

