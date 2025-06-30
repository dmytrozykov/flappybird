-- Sprite.lua

local spriteDirectory = "asset/sprite/"

---@enum Sprite
local Sprite = {
  bird = {
    love.graphics.newImage(spriteDirectory .. "bird/bird-0.png"),
    love.graphics.newImage(spriteDirectory .. "bird/bird-1.png"),
  },
  pipe = {
    spriteDirectory .. "pipe.png",
  },
}

return Sprite
