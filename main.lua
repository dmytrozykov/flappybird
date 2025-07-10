-- main.lua

-- Imports
local StateManager = require("StateManager")
local MenuState = require("state/MenuState")
local PlayState = require("state/PlayState")
local LostState = require("state/LostState")

-- Global variables
---@type StateManager
local stateManager

function love.load()
  love.window.setTitle("Flappy Bird")
  love.window.setMode(360, 800, {
    vsync = true,
    resizable = false,
  })

  stateManager = StateManager:new()

  stateManager:add(MenuState.name, MenuState:new(stateManager))
  stateManager:add(PlayState.name, PlayState:new(stateManager))
  stateManager:add(LostState.name, LostState:new(stateManager))

  stateManager:switch(MenuState.name)
end

---@param dt number
function love.update(dt)
stateManager:update(dt)
end

---@param key love.KeyConstant
---@param scancode love.Scancode
---@param isrepeat boolean
function love.keypressed(key, scancode, isrepeat)
  stateManager:keypressed(key, scancode, isrepeat)
end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function love.mousepressed(x, y, button, istouch, presses)
  stateManager:mousepressed(x, y, button, istouch, presses)
end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function love.mousereleased(x, y, button, istouch, presses)
  stateManager:mousereleased(x, y, button, istouch, presses)
end

function love.draw()
  stateManager:draw()
end

