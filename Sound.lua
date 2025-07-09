-- Sound.lua

local soundDirectory = "asset/sfx/"

---@enum Sounds
local Sound = {
  flap = love.audio.newSource(soundDirectory .. "flap.mp3", "static"),
  beep = love.audio.newSource(soundDirectory .. "beep.mp3", "static")
}

return Sound
