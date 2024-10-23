---@class unitMgr
local unitMgr = Class 'unitMgr'
---@enum(key) FW.unitMgr.unitType
unitMgr.unitType = {
    enemy = "enemy",
    summoner = "summoner",
    followHero = "followHero",
}
unitMgr.unitTemple = {
    ---@enum(key) FW.unitMgr.enemyUnitType
    enemy = {
        enemy1 = require 'scripts.unit.enemy.enemy1',
    },
    ---@enum(key) FW.unitMgr.summonerUnitType
    summoner = {
        summoner1 = require 'scripts.unit.summoner.summoner1'
    },
    ---@enum(key) FW.unitMgr.followHeroUnitType
    followHero = {

    }
}
unitMgr.units = {
    enemy = {},
    hero = {},
    followHero = {}
}
---@param ownerId string 怪物这里的所有者还是玩家
---@param unitType FW.unitMgr.unitType
---@param unit Unit
local function add_unitGroup(ownerId, unitType, unit)
    if unitMgr.units[unitType][ownerId] == nil then
        unitMgr.units[unitType][ownerId] = y3.unit_group.create()
    end
    unitMgr.units[unitType][ownerId]:add_unit(unit)
end

---@param owner Player 怪物这里的所有者还是玩家
---@param point Point 点
---@param unitType? FW.unitMgr.unitType
---@param unitSubType? FW.unitMgr.enemyUnitType|FW.unitMgr.summonerUnitType|FW.unitMgr.followHeroUnitType
---@param direction? number 方向
---@param unitTemplate? table 模版 传了这个前面的type类型直接无视
---@return Unit unit
function unitMgr:createUnit(owner, point, unitType, unitSubType, direction, unitTemplate)
    direction = direction or 0
    unitTemplate = unitTemplate or nil
    local template = nil
    local ownerId = owner:get_id()
    if unitTemplate ~= nil then
        template = unitTemplate
        unitType = unitTemplate.type
        
    else
        template = self.unitTemple[unitType][unitSubType]
    end
    if unitType == "enemy" then
        owner = y3.player.get_by_id(ownerId + 30)
    end
    local unit = template:create(owner, point, direction)
    unit:kv_save('template', template)
    if unitType == "enemy" then
        unit:kv_save("ownerId", ownerId)
        unit:add_tag('enemy')
    elseif unitType == "summoner" then
        unit:add_tag('summoner')
    elseif unitType == "followHero" then
        unit:add_tag('followHero')
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    add_unitGroup(ownerId, unitType, unit)
    return unit
end

---@param owner Player
---@param unitType FW.unitMgr.unitType
---@param point Point 点
---@param direction? number 方向
---@return Unit unit
function unitMgr:createRandomUnit(owner, unitType, point, direction)
    local template = FW.util:randomValueInTable(self.unitTemple[unitType])
    local unit = template:create(owner, point, direction)
    return unit
end

-- ---@param owner Player|Unit
-- ---@param type string
-- ---@param area Area
-- ---@param direction number 方向
-- ---@param count number 数量
-- ---@param enemy Player|Unit
-- function M:createRandomUnitAtRandomPoint(owner, type, area, direction, count, enemy)
--     for i = 1, count, 1 do
--         local template = FW.util:randomValueInTable(self.unitTemple[type])
--         local point = area:random_point()
--         local unit = template:create(owner, point, direction)
--         unit:kv_save('template', template)
--         local ori_max_hp = unit:get_attr_base(y3.const.UnitAttr['最大生命'])
--         local ori_attack_phy = unit:get_attr_base(y3.const.UnitAttr['物理攻击'])
--         unit:add_attr(y3.const.UnitAttr['最大生命'], (FW.gameMgr.currentRound - 1) * ori_max_hp)
--         unit:add_attr(y3.const.UnitAttr['物理攻击'], (FW.gameMgr.currentRound - 1) * ori_attack_phy)
--         unit:add_attr(y3.const.UnitAttr['最大生命'], (FW.gameMgr.mode - 1) * ori_max_hp)
--         unit:add_attr(y3.const.UnitAttr['物理攻击'], (FW.gameMgr.mode - 1) * ori_attack_phy)
--         unit:attack_target(enemy, 0)
--         add_unitGroup(owner, type, unit, point)
--     end
-- end

function unitMgr:killAllEnemyByPlayerId(playerId)
    local enemyGroup = self.units.enemy[playerId]
    for index, value in ipairs(enemyGroup:pick()) do
        value:kill_by(nil)
    end
    enemyGroup:clear()
end

function unitMgr:killAllEnemy()
    for key, value in pairs(self.units.enemy) do
        self:killAllEnemyByPlayerId(key)
    end
end

return unitMgr
