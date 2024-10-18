local M = {}
M.id = 134256863
M.template = y3.object.unit[M.id] --物编信息

---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    local unit = y3.unit.create_unit(owner, self.id, point, direction)
    unit:add_state('无法控制')
    unit:add_state('无法被选中')
    unit:add_state('无法被攻击')
    return unit
end

return M
