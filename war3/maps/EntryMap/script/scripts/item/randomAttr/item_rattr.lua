--随机添加属性
local M = {}
M.id = 134266585
M.lua_name = 'rattr'
M.item_type = 'randomAttr'
M.name = '随机添加属性'
M.desc = '描述'
M.price_type = 'gold'
M.price = 1000
M.random_table = 'randomAttr'
M.template = y3.object.item[M.id] --物编信息

M.template:event('物品-获得', function(trg, data)
    local attrs = FW.configMgr:getConfigTable(M.random_table)
    local rand = math.random(1, #attrs)
    data.unit:add_buff({ key = attrs[rand].effect_id, time = attrs[rand].effcct_timeout })
    data.unit:add_attr(attrs[rand].attr_name, attrs[rand].attr_value)
    data.item:remove()
end)

---@param owner Player
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M