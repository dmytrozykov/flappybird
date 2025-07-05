-- Pipe.lua

local Sprite = require("Sprite")

local drawScale = 10

---@class Pipe
---@field position Position
---@field pipe_sprite love.Image
---@field pipe_end_sprite love.Image
---@field moveSpeed number
local Pipe = {
  pipe_sprite = Sprite.pipe,
  pipe_end_sprite = Sprite.pipe_end,
}

---@param position Position
---@return Pipe
function Pipe:new(position)
  local pipe = {
    position = position,
    moveSpeed = 50,
  }
  setmetatable(pipe, {__index = self})
  return pipe
end

function Pipe:draw()
  local offset = 150
  local _, height = love.graphics.getDimensions()

  local pipe_end_image = Pipe.pipe_end_sprite
  pipe_end_image:setFilter("nearest", "nearest")


  local verticalPosition = self.position.y - offset

  local scale = drawScale
  love.graphics.draw(pipe_end_image, self.position.x, verticalPosition, 0, scale, scale)

  local pipe_image = Pipe.pipe_sprite
  pipe_image:setFilter("nearest", "nearest")

  local spriteHeight = pipe_image:getHeight() * scale
  local numberOfSprites = ((height - verticalPosition) / spriteHeight) + 1

  for _ = 1, numberOfSprites do
    verticalPosition = verticalPosition - spriteHeight
    love.graphics.draw(pipe_image, self.position.x, verticalPosition, 0, scale, scale)
  end

  verticalPosition = self.position.y + offset + spriteHeight

  love.graphics.draw(pipe_end_image, self.position.x, verticalPosition, 0, scale, -scale)

  for _ = 1, numberOfSprites do
    love.graphics.draw(pipe_image, self.position.x, verticalPosition, 0, scale, scale)
    verticalPosition = verticalPosition + spriteHeight
  end
end

---@param dt number
function Pipe:update(dt)
  self.position.x = self.position.x - self.moveSpeed * dt

  local width, _ = love.graphics.getDimensions()

  if self.position.x + (self.pipe_sprite:getWidth() * drawScale) < 0 then
    self.position.x = width
  end
end

return Pipe
