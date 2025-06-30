-- StateManager.lua

---@class StateManager
---@field states any[]
---@field current any
local StateManager = {}

---@return StateManager
function StateManager:new()
  local sm = {
    states = {},
    current = nil
  }
  setmetatable(sm, {__index = self})
  return sm
end

---@param name string
---@param state any
function StateManager:add(name, state)
  self.states[name] = state
end

---@param name string
---@param ... any
function StateManager:switch(name, ...)
  if self.current then
    if self.current.exit then
      self.current:exit()
    end
  end

  self.current = self.states[name]
  if self.current and self.current.enter then
    self.current:enter(...)
  end
end

---@param dt number
function StateManager:update(dt)
  if self.current and self.current.update then
    self.current:update(dt)
  end
end

function StateManager:draw()
  if self.current and self.current.draw then
    self.current:draw()
  end
end

---@param key love.KeyConstant
---@param scancode love.Scancode
---@param isrepeat boolean
function StateManager:keypressed(key, scancode, isrepeat)
  if self.current and self.current.keypressed then
    self.current:keypressed(key, scancode, isrepeat)
  end
end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function StateManager:mousepressed(x, y, button, istouch, presses)
  if self.current and self.current.mousepressed then
    self.current:mousepressed(x, y, button, istouch, presses)
  end
end

---@param x number
---@param y number
---@param button number
---@param istouch boolean
---@param presses number
function StateManager:mousereleased(x, y, button, istouch, presses)
  if self.current and self.current.mousepressed then
    self.current:mousereleased(x, y, button, istouch, presses)
  end
end


return StateManager
