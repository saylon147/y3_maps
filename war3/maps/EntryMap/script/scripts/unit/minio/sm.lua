--萨满
local M = {}
M.id = 134264703
M.template = y3.object.unit[M.id] --物编信息
M.type = 'minio'
---not refresh code---




M.template:event("单位-死亡",function (trg, data)
    
end)

---@param unit Unit
local function addAbilitys(unit)
    
end




---not refresh code---
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