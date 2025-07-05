-- PlayState.lua
local Colors = require("Colors")
local Bird = require("Bird")
local Pipe = require("Pipe")

-- Constants
local PIPE_SPAWN_OFFSET = 150
local ESCAPE_KEY = "escape"
local MENU_STATE_NAME = "MenuState"

---@class PlayState
---@field name string
---@field stateManager StateManager
---@field bird Bird
---@field pipe Pipe
---@field screenWidth number
---@field screenHeight number
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

---Calculate initial pipe position
---@return Position
function PlayState:getPipeSpawnPosition()
    local width, height = self:getScreenDimensions()
    return {
        x = width + PIPE_SPAWN_OFFSET,
        y = height / 2
    }
end

---Initialize game entities
function PlayState:initializeEntities()
    self.bird = Bird:new(self:getBirdSpawnPosition())
    self.pipe = Pipe:new(self:getPipeSpawnPosition())
end

---Reset game state to initial conditions
function PlayState:reset()
    -- Clear cached dimensions to get fresh values
    self.screenWidth = nil
    self.screenHeight = nil
    self:initializeEntities()
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
    state:reset()
    
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
    self.bird:draw()
    self.pipe:draw()
end

---Main draw function
function PlayState:draw()
    self:drawBackground()
    self:drawEntities()
end

---Update all game entities
---@param dt number
function PlayState:updateEntities(dt)
    self.bird:update(dt)
    self.pipe:update(dt)
end

---Main update function
---@param dt number
function PlayState:update(dt)
    self:updateEntities(dt)
end

---Handle escape key press
function PlayState:handleEscapeKey()
    self.stateManager:switch(MENU_STATE_NAME)
end

---Handle other key presses
---@param key love.KeyConstant
function PlayState:handleGameInput(key)
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