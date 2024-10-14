local M = {}
M.id = 134218046
M.template = y3.object.unit[M.id] --物编信息

---@param unit Unit
local function addAbilitys(unit)
    unit:add_ability('普通',134235512)
end

---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    local unit = y3.unit.create_unit(owner, self.id, point, direction)
    addAbilitys(unit)
    return unit
end



return M
