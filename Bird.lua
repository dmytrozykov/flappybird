-- Bird.lua

local Sprite = require("Sprite")

---@class Bird
---@field position Position
local Bird = {}

---@param position Position
---@return Bird
function Bird:new(position)
  local bird = {
    position = position,
  }
  setmetatable(bird, {__index = self})
  return bird
end

---@param dt number
function Bird:update(dt)
  
end

function Bird:draw()
  local image = Sprite.bird[1]
  image:setFilter("nearest", "nearest")

  local scale = 10
  love.graphics.draw(image, self.position.x, self.position.y, 0, scale, scale)
end

return Bird
