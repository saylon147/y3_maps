---@class mapMgr
local mapMgr = Class 'mapMgr'

---@param playerId integer 敌方建筑这里的所有者还是玩家
function mapMgr:initMap(playerId)
    local configs = FW.configMgr:getConfigTableRowByKey('map', 'owner', playerId)
    for index, config in ipairs(configs) do
        local building = self:create_building(config.id, playerId, config.type,
            y3.point.create(config.point[1], config.point[2]),config.direction)
        building:set_name(config.name)
    end
end

---@param id py.UnitKey 物编id
---@param playerId integer 敌方建筑这里的所有者还是玩家
---@param type string
---@param point Point
---@param direction number
---@return Unit building
function mapMgr:create_building(id, playerId, type, point, direction)
    local owner = y3.player.get_by_id(playerId)
    if type == "enemy" then
        owner = y3.player.get_by_id(playerId + 30)
    end
    local unit = y3.unit.create_unit(owner, id, point, direction)
    if type == 'shop' then
        unit:add_tag('shop')
    else 
        unit:add_tag('building')
    end
    return unit
end

return mapMgr
