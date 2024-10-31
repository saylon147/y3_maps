--敏捷书
local M = {}
M.id = 134243163
M.lua_name = 'mjs'
M.item_type = 'attr'
M.name = '敏捷书'
M.desc = '描述'
M.price_type = 'gold'
M.price = 1000
M.attr_name = 'agility'
M.attr_value = 100
M.template = y3.object.item[M.id] --物编信息

M.template:event('物品-获得',function (trg, data)
    data.unit:add_attr(M.attr_name,M.attr_value)
    data.item:remove()
end)

---@param owner Player
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M