--山丘之王
local M = {}
M.id = 134242228
M.template = y3.object.unit[M.id] --物编信息
M.type = 'summoner'

M.template:event("单位-死亡",function (trg, data)
    
end)

---@param unit Unit
local function addAbilitys(unit)
    --unit:add_ability('普通',134235512)
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