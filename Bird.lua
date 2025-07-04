-- Bird.lua

local Sprite = require("Sprite")

---@class Bird
---@field sprite love.Image
---@field position Position
---@field velocity Velocity
---@field gravityForce number
---@field flapForce number
local Bird = {
  gravityForce = 1500,
  flapForce = 600,
}

---@param position Position
---@return Bird
function Bird:new(position)
  local bird = {
    sprite = Sprite.bird[1],
    position = position,
    velocity = {x=0, y=0}
  }
  setmetatable(bird, {__index = self})
  return bird
end

---@param dt number
function Bird:update(dt)
  -- Apply gravity
  self.velocity.y = self.velocity.y + Bird.gravityForce * dt

  -- Update sprite
  if self.velocity.y >= 0 then
    self.sprite = Sprite.bird[1]
  else
    self.sprite = Sprite.bird[2]
  end

  -- Apply velocity
  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt
end

function Bird:draw()
  local image = self.sprite
  image:setFilter("nearest", "nearest")

  local scale = 10
  love.graphics.draw(image, self.position.x, self.position.y, 0, scale, scale)
end

---@param key love.KeyConstant
function Bird:keypressed(key)
  if key == "space" then
    self.velocity.y = -Bird.flapForce
  end
end

return Bird
