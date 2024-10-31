--增加金币收益
local M = {}
M.id = 134263503
M.lua_name = 'jbsy'
M.item_type = 'kv'
M.name = '增加金币收益'
M.desc = '描述'
M.price_type = 'gold'
M.price = 1000
M.kv_key = 'gold_grow'
M.kv_value = 100
M.template = y3.object.item[M.id] --物编信息

M.template:event('物品-获得',function (trg, data)
    local player = data.unit:get_owner();
    local value = M.kv_value
    if player:kv_has(M.kv_key) then
        value = value + tonumber(player:kv_load(M.kv_key,'string'))
    end
    player:kv_save(M.kv_key,tostring(value))
end)

---@param owner Player
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M