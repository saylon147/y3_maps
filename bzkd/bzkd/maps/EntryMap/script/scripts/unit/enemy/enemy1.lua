local M = {}
M.id = 134241530
M.template = y3.object.unit[M.id] --物编信息

M.template:event("单位-死亡",function (trg, data)
    local point = data.unit:get_point()
    local id = FW.playerMgr:getPlayerIdByPoint(data.unit, point)
    local owner = y3.player.get_by_id(id)
    FW.unitMgr:createUnit(owner,'pickUnit','exp',point,0)
    local rand = math.random(100)
    if(rand <= 30) then
        FW.unitMgr:createUnit(owner,'pickUnit','gold',point,0)
    end
    if(rand <= 10) then
        FW.unitMgr:createUnit(owner,'pickUnit','health',point,0)
    end
end)

---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    return y3.unit.create_unit(owner, self.id, point, direction)
end

return M
