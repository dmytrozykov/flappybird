-- Pipe.lua
local Sprite = require("Sprite")

-- Constants
local DRAW_SCALE = 10
local PIPE_OFFSET = 173
local DEFAULT_MOVE_SPEED = 50

---@class Pipe
---@field position Position
---@field moveSpeed number
---@field drawScale number
---@field pipeOffset number
local Pipe = {}

---@param position Position
---@param moveSpeed number?
---@param drawScale number?
---@param pipeOffset number?
---@return Pipe
function Pipe:new(position, moveSpeed, drawScale, pipeOffset)
    local pipe = {
        position = position,
        moveSpeed = moveSpeed or DEFAULT_MOVE_SPEED,
        drawScale = drawScale or DRAW_SCALE,
        pipeOffset = pipeOffset or PIPE_OFFSET,
    }
    
    setmetatable(pipe, {__index = self})
    
    -- Initialize sprite filters once
    self:initializeSprites()
    
    return pipe
end

---Initialize sprite filters (called once)
function Pipe:initializeSprites()
    if not Pipe._spritesInitialized then
        Sprite.pipe:setFilter("nearest", "nearest")
        Sprite.pipeEnd:setFilter("nearest", "nearest")
        Pipe._spritesInitialized = true
    end
end

---Calculate pipe drawing parameters
---@param offset number
---@return number verticalPosition
---@return number orientationFactor
---@return number spriteHeight
---@return number numberOfSprites
---@return number startIndex
function Pipe:calculatePipeDrawingParams(offset)
    local verticalPosition = self.position.y + offset
    local orientationFactor = offset < 0 and -1 or 1
    
    local screenHeight = love.graphics.getHeight()
    local spriteHeight = Sprite.pipe:getHeight() * self.drawScale
    local numberOfSprites = math.ceil((screenHeight - verticalPosition) / spriteHeight) + 1
    local startIndex = offset < 0 and 1 or 0
    
    return verticalPosition, orientationFactor, spriteHeight, numberOfSprites, startIndex
end

---Draw pipe end cap
---@param verticalPosition number
---@param orientationFactor number
function Pipe:drawPipeEnd(verticalPosition, orientationFactor)
    love.graphics.draw(
        Sprite.pipeEnd, 
        self.position.x, 
        verticalPosition, 
        0, 
        self.drawScale, 
        self.drawScale * -orientationFactor
    )
end

---Draw pipe body segments
---@param verticalPosition number
---@param orientationFactor number
---@param spriteHeight number
---@param numberOfSprites number
---@param startIndex number
function Pipe:drawPipeBody(verticalPosition, orientationFactor, spriteHeight, numberOfSprites, startIndex)
    for i = startIndex, numberOfSprites + 1 do
        local newVerticalPosition = verticalPosition + spriteHeight * orientationFactor * i
        love.graphics.draw(
            Sprite.pipe, 
            self.position.x, 
            newVerticalPosition, 
            0, 
            self.drawScale, 
            self.drawScale
        )
    end
end

---Draw a single pipe (top or bottom)
---@param offset number
function Pipe:drawPipe(offset)
    local verticalPosition, orientationFactor, spriteHeight, numberOfSprites, startIndex = 
        self:calculatePipeDrawingParams(offset)
    
    self:drawPipeEnd(verticalPosition, orientationFactor)
    self:drawPipeBody(verticalPosition, orientationFactor, spriteHeight, numberOfSprites, startIndex)
end

---Draw both pipes (top and bottom)
function Pipe:draw()
    self:drawPipe(-self.pipeOffset)
    self:drawPipe(self.pipeOffset)
end

---Get pipe width for collision detection and positioning
---@return number
function Pipe:getWidth()
    return Sprite.pipe:getWidth() * self.drawScale
end

---Check if pipe is off screen
---@return boolean
function Pipe:isOffScreen()
    return self.position.x + self:getWidth() < 0
end

---@return AABB top, AABB bottom
function Pipe:getAABBs()
    local verticalPosition, _, spriteHeight, _, _ = self:calculatePipeDrawingParams(-self.pipeOffset)
    local height = verticalPosition + spriteHeight
    local width = (Sprite.pipe:getWidth() - 2) * DRAW_SCALE
    local horizontalPosition = self.position.x + 1 * DRAW_SCALE

    ---@type AABB
    local top = {
        x = horizontalPosition,
        y = 0,
        width = width,
        height = height,
    }

    verticalPosition, _, _, _ = self:calculatePipeDrawingParams(self.pipeOffset)
    verticalPosition = verticalPosition - spriteHeight

    local bottom = {
        x = horizontalPosition,
        y = verticalPosition,
        width = width,
        height = love.graphics.getHeight() - verticalPosition,
    }

    return top, bottom
end

---Update pipe position
---@param dt number
---@param onOffScreen function
function Pipe:update(dt, onOffScreen)
    self.position.x = self.position.x - self.moveSpeed * dt
    
    if self:isOffScreen() then
        onOffScreen()
    end
end

return Pipe