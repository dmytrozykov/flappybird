-- Font.lua

local fontDirectory = "asset/font/"

local FontFamily = {
  upheaval = fontDirectory .. "upheavtt.ttf",
}

---@enum Font
local Font = {
  upheaval = {
    score = love.graphics.newFont(FontFamily.upheaval, 72),
    title = love.graphics.newFont(FontFamily.upheaval, 48),
    paragraph = love.graphics.newFont(FontFamily.upheaval, 24)
  },
}

return Font
