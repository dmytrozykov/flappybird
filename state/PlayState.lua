-- PlayState.lua
local Colors = require("Colors")
local Bird = require("Bird")
local Pipe = require("Pipe")
local Collision = require("Collision")
local DebugSettings = require("DebugSettings")
local Font = require("Font")
local Sound = require("Sound")

-- Constants
local PIPE_SPAWN_DELAY = 4
local LOST_SCREEN_DELAY = 2
local ESCAPE_KEY = "escape"
local MENU_STATE_NAME = "MenuState"

---@class PlayState
---@field name string
---@field stateManager StateManager
---@field bird Bird
---@field pipes Pipe[]
---@field pipeSpawnTimer number
---@filed lostTimer number
---@field screenWidth number
---@field screenHeight number
---@field score number
---@field lost boolean
local PlayState = {
    name = "PlayState"
}

---Cache screen dimensions to avoid repeated calls
function PlayState:getScreenDimensions()
    if not self.screenWidth or not self.screenHeight then
        self.screenWidth, self.screenHeight = love.graphics.getDimensions()
    end
    return self.screenWidth, self.screenHeight
end

---Calculate center position for bird spawn
---@return Position
function PlayState:getBirdSpawnPosition()
    local width, height = self:getScreenDimensions()
    return {
        x = width / 2,
        y = height / 2
    }
end

---Calculate pipe spawn position
---@return Position
function PlayState:getPipeSpawnPosition()
    local width, height = self:getScreenDimensions()
    local screenBasedOffset = height * 0.2
    local randomOffset = math.random(-screenBasedOffset, screenBasedOffset)

    -- First pipe should not have any offset
    if #self.pipes == 0 then
        randomOffset = 0
    end

    return {
        x = width,
        y = height / 2 + randomOffset
    }
end

---Initialize game entities
function PlayState:initializeEntities()
    self.bird = Bird:new(self:getBirdSpawnPosition())
    self.pipes = {}
end

function PlayState:initializeTimers()
    self.pipeSpawnTimer = 0
    self.lostTimer = 0
end

---Reset game state to initial conditions
function PlayState:reset()
    -- Clear cached dimensions to get fresh values
    self.score = 0
    self.lost = false
    self.screenWidth = nil
    self.screenHeight = nil
    self:initializeEntities()
    self:initializeTimers()
end

---Constructor for PlayState
---@param stateManager StateManager
---@return PlayState
function PlayState:new(stateManager)
    ---@type PlayState
    local state = {
        stateManager = stateManager,
    }
    setmetatable(state, {__index = self})
    return state
end

---Called when entering this state
function PlayState:enter()
    self:reset()
end

---Draw background
function PlayState:drawBackground()
    love.graphics.setBackgroundColor(Colors.background)
end

---Draw all game entities
function PlayState:drawEntities()
    -- Draw pipes
    for _, pipe in ipairs(self.pipes) do
        pipe:draw()

        if DebugSettings.drawAABBs then
            local top, bottom = pipe:getAABBs()
            Collision.drawAABB(top)
            Collision.drawAABB(bottom)
        end
    end

    self.bird:draw()
    if DebugSettings.drawAABBs then
        Collision.drawAABB(self.bird:getAABB())
    end
end

function PlayState:drawScore()
    local font = Font.upheaval.score
    local shadowOffset = 5
    local width = font:getWidth(self.score) + shadowOffset
    local x, y = self.screenWidth / 2 - width / 2, 15

    love.graphics.setFont(font)

    -- Draw shadow
    love.graphics.setColor(Colors.shadow)
    love.graphics.print(self.score, x + shadowOffset, y + shadowOffset)

    -- Draw score
    love.graphics.setColor(Colors.text)
    love.graphics.print(self.score, x, y)

end

---Main draw function
function PlayState:draw()
    self:drawBackground()
    self:drawEntities()
    self:drawScore()
end

---Update all game entities
---@param dt number
function PlayState:updateEntities(dt)
    self.bird:update(dt)

    if self.lost then
        return
    end
    
    -- Update pipes
    for i, pipe in ipairs(self.pipes) do
        local onOffScreen = function ()
            table.remove(self.pipes, i)
        end
        pipe:update(dt, onOffScreen)
    end
end

function PlayState:spawnPipe()
    local pipe = Pipe:new(self:getPipeSpawnPosition())
    table.insert(self.pipes, pipe)
end

---@param dt number
function PlayState:updatePipeTimer(dt)
    self.pipeSpawnTimer = self.pipeSpawnTimer + dt
    if self.pipeSpawnTimer >= PIPE_SPAWN_DELAY then
        self:spawnPipe()
        self.pipeSpawnTimer = self.pipeSpawnTimer - PIPE_SPAWN_DELAY
    end
end

---@param dt number
function PlayState:updateLostTimer(dt)
    self.lostTimer = self.lostTimer + dt
    if self.lostTimer >= LOST_SCREEN_DELAY then
        self.stateManager:switch("LostState")
    end
end

---@param pipe Pipe
function PlayState:checkScore(pipe)
    if pipe:getIsPassed(self.bird.position) then
        Sound.beep:stop()
        Sound.beep:play()
        self.score = self.score + 1
    end
end

function PlayState:lose()
    self.lost = true
    Sound.lose:play()
end

function PlayState:checkBounds()
    local aabb = self.bird:getAABB()
    if aabb.y + aabb.height > love.graphics.getHeight() or aabb.y < 0 then
        self:lose()
    end
end

function PlayState:checkCollisions()
    local birdAABB = self.bird:getAABB()
    for _, pipe in ipairs(self.pipes) do
        local topAABB, bottomAABB = pipe:getAABBs()
        if Collision.checkCollision(birdAABB, topAABB) or
           Collision.checkCollision(birdAABB, bottomAABB) then
            self:lose()
            return
        end

        self:checkScore(pipe)
    end
end

---Main update function
---@param dt number
function PlayState:update(dt)
    self:updateEntities(dt)
    if not self.lost then
        self:updatePipeTimer(dt)
        self:checkCollisions()
        self:checkBounds()
    else
        self:updateLostTimer(dt)
    end
end

---Handle escape key press
function PlayState:handleEscapeKey()
    self.stateManager:switch(MENU_STATE_NAME)
end

---Handle other key presses
---@param key love.KeyConstant
function PlayState:handleGameInput(key)
    if self.lost then
        return
    end
    self.bird:keypressed(key)
end

---Main key press handler
---@param key love.KeyConstant
function PlayState:keypressed(key)
    if key == ESCAPE_KEY then
        self:handleEscapeKey()
    else
        self:handleGameInput(key)
    end
end

return PlayState