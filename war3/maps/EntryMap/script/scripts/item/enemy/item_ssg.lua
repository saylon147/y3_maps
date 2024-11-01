--食尸鬼
local M = {}
M.id = 134254575
M.lua_name = 'ssg'
M.item_type = 'enemy'
M.name = '食尸鬼'
M.desc = '描述'
M.price_type = 'wood'
M.price = 1000
M.effcct_buff = '升级'
M.template = y3.object.item[M.id] --物编信息

M.template:event('物品-获得',function (trg, data)
   local buffs = FW.configMgr:getConfigTableRowByKey('buff','buff_name',M.effcct_buff)
    local buff = nil
    if #buffs > 0 then
        buff = buffs[1]
    end
    if buff then
        data.unit:add_buff({ key = buff.id, time = buff.timeout })
    end
    local player = data.unit:get_owner();
    local enemy_count = tonumber(player:kv_load('enemy_count','string'))
    for i = 1, enemy_count, 1 do
        local unit = FW.unitMgr:createUnit(player,'enemy',nil,M.name,FW.const.enemyBornPoint[player:get_id()])
        unit:attack_move(FW.const.bornPoint[player:get_id()])
    end
    data.item:remove()
end)


---@param owner Player
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M