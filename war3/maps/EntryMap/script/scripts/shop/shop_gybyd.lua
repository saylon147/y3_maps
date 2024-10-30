--雇佣兵营地
local M = {}
M.id = 134257687
M.template = y3.object.unit[M.id] --物编信息

M.items = {
    {
        itemTemplate = FW.itemMgr.itemTemplate['木材'],
        priceType = 'gold'
    },
    {
        itemTemplate = FW.itemMgr.itemTemplate['金币'],
        priceType = 'wood'
    },
    {
        itemTemplate = FW.itemMgr.itemTemplate['经验'],
        priceType = 'gold'
    },
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
