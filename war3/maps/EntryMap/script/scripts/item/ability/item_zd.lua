--释放范围爆炸
local M = {}
M.id = 134257112
M.lua_name = 'zd'
M.item_type = 'ability'
M.name = '释放范围爆炸'
M.desc = '描述'
M.price_type = 'wood'
M.price = 1000
M.ability_key = 134269127
M.template = y3.object.item[M.id] --物编信息


---@param owner Player
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M