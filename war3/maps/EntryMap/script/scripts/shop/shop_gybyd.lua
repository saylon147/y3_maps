--雇佣兵营地
local M = {}
M.id = 134257687
M.lua_name = 'gybyd'
M.name = '雇佣兵营地'
M.desc = '描述'
M.template = y3.object.item[M.id] --物编信息


---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    local unit = y3.unit.create_unit(owner, self.id, point, direction)
    return unit
end
return M