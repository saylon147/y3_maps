local M = {}
M.id = 134274912
---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    return y3.unit.create_unit(owner, self.id, point, direction)
end

return M