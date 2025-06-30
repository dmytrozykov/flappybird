-- main.lua

function love.load()
  -- Initaliziation goes here
end

---@param dt number
function love.update(dt)
  -- Update goes here
end

---@param key love.KeyConstant
---@param scancode love.Scancode
---@param isrepeat boolean
function love.keypressed(key, scancode, isrepeat)
  -- Key press logic goes here
  print("Key '" .. key .. "' pressed!")
end

---@param key love.KeyConstant
---@param scancode love.Scancode
function love.keyreleased(key, scancode)
  -- Key release logic goes here
  print("Key '" .. key .. "' released!")
end

function love.draw()
  -- Draw goes here
  love.graphics.print("Flappy Bird", 300, 400)
end

