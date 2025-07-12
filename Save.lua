local json = require("third-party.json")

-- Constants
local SAVEFILE = "save.json"

local Save = {}

---@return number?
Save.loadHighscore = function ()
    if love.filesystem.getInfo(SAVEFILE) then
        local contents = love.filesystem.read(SAVEFILE)
        local saveData = json.decode(contents)
        return saveData.highScore
    end
    return nil
end

---@param highScore number
Save.saveHighscore = function (highScore)
    local dataString = json.encode({
        highScore = highScore
    })
    love.filesystem.write(SAVEFILE, dataString)
end

return Save