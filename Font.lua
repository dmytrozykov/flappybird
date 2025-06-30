-- Font.lua

local fontDirectory = "asset/font/"

local FontFamily = {
  upheaval = fontDirectory .. "upheavtt.ttf",
}

---@enum Font
local Font = {
  upheaval = {
    title = love.graphics.newFont(FontFamily.upheaval, 48),
    paragraph = love.graphics.newFont(FontFamily.upheaval, 24)
  },
}

return Font
