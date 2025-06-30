-- Button.lua

local Colors = require("Colors")
local ScreenSpace = require("ScreenSpace")

---@class Button
---@field x number
---@field y number
---@field width number
---@field height number
---@field text string
---@field font love.Font
---@field onClick function
---@field isHovered boolean
---@field isPressed boolean
local Button = {}

---@param x number
---@param y number
---@param width number
---@param height number
---@param text string
---@return Button
function Button:new(x, y, width, height, text)
  local button = {
    x = x,
    y = y,
    width = width,
    height = height,
    text = text,
    onClick = function() end,

    isHovered = false,
    isPressed = false,

    font = love.graphics.getFont(),
  }

  setmetatable(button, {__index = self})
  return button
end

function Button:update()
  local mx, my = love.mouse.getPosition()
  local x, y = self:getScreenPosition()

  self.isHovered = mx >= x and mx <= x + self.width and
                   my >= y and my <= y + self.height
end

---@param button number
function Button:mousepressed(button)
  if button == 1 and self.isHovered then
    self.isPressed = true
  end
end

---@param button number
function Button:mousereleased(button)
  if button == 1 and self.isPressed then
    self.isPressed = false

    if self.isHovered then
      self.onClick()
    end
  end
end

function Button:draw()
  local bgColor = Colors.button.normal
  if self.isPressed then
    bgColor = Colors.button.pressed
  elseif self.isHovered then
    bgColor = Colors.button.hover
  end

  love.graphics.setColor(bgColor)

  local x, y = self:getScreenPosition()

  love.graphics.rectangle("fill", x, y, self.width, self.height)

  love.graphics.setColor(Colors.button.text)
  love.graphics.setFont(self.font)
    
  local textWidth = self.font:getWidth(self.text)
  local textHeight = self.font:getHeight()
  local textX = x + (self.width - textWidth) / 2
  local textY = y + (self.height - textHeight) / 2

  love.graphics.print(self.text, textX, textY)
end

---@return number
---@return number
function Button:getScreenPosition()
  local x, y = ScreenSpace.toScreen(self.x, self.y)
  return x - self.width / 2, y - self.height / 2
end

return Button
