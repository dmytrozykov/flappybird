-- Bird.lua
local Sprite = require("Sprite")
local Sound = require("Sound")

-- Constants
local DEFAULT_GRAVITY_FORCE = 1500
local DEFAULT_FLAP_FORCE = 550
local DEFAULT_SCALE = 10
local FLAP_KEY = "space"
local SPRITE_FILTER = "nearest"

-- Animation constants
local FALLING_SPRITE_INDEX = 1
local RISING_SPRITE_INDEX = 2

---@class Bird
---@field sprite love.Image
---@field position Position
---@field velocity Velocity
---@field gravityForce number
---@field flapForce number
---@field scale number
---@field flapSound love.Source
---@field spriteInitialized boolean
local Bird = {}

---Initialize default values
function Bird:getDefaults()
    return {
        gravityForce = DEFAULT_GRAVITY_FORCE,
        flapForce = DEFAULT_FLAP_FORCE,
        scale = DEFAULT_SCALE,
        flapSound = Sound.flap
    }
end

---Create a new Bird instance
---@param position Position
---@param gravityForce number?
---@param flapForce number?
---@param scale number?
---@return Bird
function Bird:new(position, gravityForce, flapForce, scale)
    local defaults = self:getDefaults()
    
    local bird = {
        sprite = Sprite.bird[FALLING_SPRITE_INDEX],
        position = position,
        velocity = {x = 0, y = 0},
        gravityForce = gravityForce or defaults.gravityForce,
        flapForce = flapForce or defaults.flapForce,
        scale = scale or defaults.scale,
        flapSound = defaults.flapSound,
        spriteInitialized = false
    }
    
    setmetatable(bird, {__index = self})
    bird:initializeSprite()
    
    return bird
end

---Initialize sprite filter settings
function Bird:initializeSprite()
    if not self.spriteInitialized then
        for _, sprite in ipairs(Sprite.bird) do
            sprite:setFilter(SPRITE_FILTER, SPRITE_FILTER)
        end
        self.spriteInitialized = true
    end
end

---Apply gravity to the bird
---@param dt number
function Bird:applyGravity(dt)
    self.velocity.y = self.velocity.y + self.gravityForce * dt
end

---Update sprite based on velocity direction
function Bird:updateSprite()
    if self.velocity.y >= 0 then
        self.sprite = Sprite.bird[FALLING_SPRITE_INDEX]
    else
        self.sprite = Sprite.bird[RISING_SPRITE_INDEX]
    end
end

---Apply velocity to position
---@param dt number
function Bird:applyVelocity(dt)
    self.position.x = self.position.x + self.velocity.x * dt
    self.position.y = self.position.y + self.velocity.y * dt
end

---Check if bird is falling
---@return boolean
function Bird:isFalling()
    return self.velocity.y >= 0
end

---Check if bird is rising
---@return boolean
function Bird:isRising()
    return self.velocity.y < 0
end

---Get current velocity magnitude
---@return number
function Bird:getVelocityMagnitude()
    return math.sqrt(self.velocity.x^2 + self.velocity.y^2)
end

---Set horizontal velocity
---@param vx number
function Bird:setHorizontalVelocity(vx)
    self.velocity.x = vx
end

---Stop all movement
function Bird:stop()
    self.velocity.x = 0
    self.velocity.y = 0
end

---Main update function
---@param dt number
function Bird:update(dt)
    self:applyGravity(dt)
    self:updateSprite()
    self:applyVelocity(dt)
end

---@return AABB
function Bird:getAABB()
    return {
        x = self.position.x + (1 * self.scale),
        y = self.position.y + (2 * self.scale),
        width = (self.sprite:getWidth() - 3) * self.scale,
        height = (self.sprite:getHeight() - 3) * self.scale,
    }
end

---Draw the bird
function Bird:draw()
    love.graphics.draw(
        self.sprite,
        self.position.x,
        self.position.y,
        0,
        self.scale,
        self.scale
    )
end

---Play flap sound safely
function Bird:playFlapSound()
    if self.flapSound then
        self.flapSound:stop()
        self.flapSound:play()
    end
end

---Make the bird flap
function Bird:flap()
    self:playFlapSound()
    self.velocity.y = -self.flapForce
end

---Handle flap input
function Bird:handleFlapInput()
    self:flap()
end

---Handle key press events
---@param key love.KeyConstant
function Bird:keypressed(key)
    if key == FLAP_KEY then
        self:handleFlapInput()
    end
end

---Handle mouse press events (for touch/click controls)
---@param x number
---@param y number
---@param button number
function Bird:mousepressed(x, y, button)
    if button == 1 then -- Left mouse button
        self:handleFlapInput()
    end
end

---Reset bird to initial state
---@param position Position
function Bird:reset(position)
    self.position = position
    self.velocity = {x = 0, y = 0}
    self.sprite = Sprite.bird[FALLING_SPRITE_INDEX]
end

---Get bird's current animation state
---@return string
function Bird:getAnimationState()
    return self:isFalling() and "falling" or "rising"
end

---Set custom flap sound
---@param sound love.Source
function Bird:setFlapSound(sound)
    self.flapSound = sound
end

---Get current sprite index
---@return number
function Bird:getCurrentSpriteIndex()
    return self:isFalling() and FALLING_SPRITE_INDEX or RISING_SPRITE_INDEX
end

return Bird