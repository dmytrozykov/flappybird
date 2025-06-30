-- ScreenSpace.lua

local ScreenSpace = {}

---@param normalizedX number
---@return number
function ScreenSpace.toScreenX(normalizedX)
  return (normalizedX + 1) * (love.graphics.getWidth() * 0.5)
end

---@param normalizedY number
---@return number
function ScreenSpace.toScreenY(normalizedY)
  return (normalizedY + 1) * (love.graphics.getHeight() * 0.5)
end

---@param normalizedX number
---@param normalizedY number
---@return number
---@return number
function ScreenSpace.toScreen(normalizedX, normalizedY)
  return ScreenSpace.toScreenX(normalizedX), ScreenSpace.toScreenY(normalizedY)
end

return ScreenSpace
