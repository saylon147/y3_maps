--召唤底座之术
local M = {}
M.id = 134279339
M.template = y3.object.unit[M.id] --物编信息

M.items = {
}

---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    local unit = y3.unit.create_unit(owner, self.id, point, direction)
    return unit
end
return M
