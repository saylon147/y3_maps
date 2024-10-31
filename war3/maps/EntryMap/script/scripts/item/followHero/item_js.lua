--剑圣
local M = {}
M.id = 134244374
M.lua_name = 'js'
M.item_type = 'followHero'
M.name = '剑圣'
M.desc = '描述'
M.price_type = 'gold'
M.price = 1000
M.template = y3.object.item[M.id] --物编信息

M.template:event('物品-获得', function(trg, data)
    local player = data.unit:get_owner();
    local point = data.unit:get_point();
    FW.unitMgr:createUnit(player, 'followHero', nil, M.name,point)
    data.item:remove()
end)

---@param owner Player
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M