-- Sprite.lua

local spriteDirectory = "asset/sprite/"

---@enum Sprite
local Sprite = {
  bird = {
    love.graphics.newImage(spriteDirectory .. "bird/bird-0.png"),
    love.graphics.newImage(spriteDirectory .. "bird/bird-1.png"),
  },
  pipe = love.graphics.newImage(spriteDirectory .. "pipe/pipe.png"),
  pipeEnd = love.graphics.newImage(spriteDirectory .. "pipe/pipe-end.png"),
}

return Sprite
