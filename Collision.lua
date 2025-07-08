local Collision = {}

---@class AABB
---@field x number
---@field y number
---@field width number
---@field height number

---@param a AABB
---@param b AABB
---@return boolean
Collision.checkCollision = function (a, b)
    return a.x < b.x + b.width and
           b.x < a.x + a.width and
           a.y < b.y + b.height and
           b.y < a.y + a.height
end

---@param box AABB
Collision.drawAABB = function (box)
    love.graphics.rectangle("line", box.x, box.y, box.width, box.height)
end

return Collision
