---@class unitMgr
local unitMgr = Class 'unitMgr'
---@enum(key) FW.unitMgr.unitType
unitMgr.unitType = {
    boss = "boss",
    enemy = "enemy",
    summoner = "summoner",
    followHero = "followHero",
    minio = "minio"
}
---autocode---
unitMgr.unitTemple = {
    ---@enum(key) FW.unitMgr.bossUnitType
    boss = {},
    ---@enum(key) FW.unitMgr.enemyUnitType
    enemy = {
        ['食尸鬼'] = require 'scripts.unit.enemy.ssg',
    },
    ---@enum(key) FW.unitMgr.summonerUnitType
    summoner = {
        summoner1 = require 'scripts.unit.summoner.summoner1'
    },
    ---@enum(key) FW.unitMgr.followHeroUnitType
    followHero = {
        ['山丘之王'] = require 'scripts.unit.followHero.sqzw'
    },
    ---@enum(key) FW.unitMgr.minioUnitType
    minio = {
        ['牛头'] = require 'scripts.unit.minio.nt'
    }
}
---autocode---
unitMgr.units = {
    boss = {},
    enemy = {},
    summoner = {},
    followHero = {},
    minio = {}
}
---@param ownerId integer 怪物这里的所有者还是玩家
---@param unitType FW.unitMgr.unitType
---@param unit Unit
local function add_unitGroup(ownerId, unitType, unit)
    if unitMgr.units[unitType][ownerId] == nil then
        unitMgr.units[unitType][ownerId] = y3.unit_group.create()
    end
    unitMgr.units[unitType][ownerId]:add_unit(unit)
end

---@param owner Player 怪物这里的所有者还是玩家
---@param unitType FW.unitMgr.unitType
---@param unitTemplate? table 模版 传了这个前面的type类型直接无视
---@param unitSubType? FW.unitMgr.enemyUnitType|FW.unitMgr.summonerUnitType|FW.unitMgr.followHeroUnitType|FW.unitMgr.minioUnitType
---@param point? Point 点
---@param direction? number 方向
---@return Unit unit
function unitMgr:createUnit(owner, unitType, unitTemplate, unitSubType, point, direction)
    point = point or y3.point.create(0, 0, 0)
    direction = direction or 0
    unitTemplate = unitTemplate or nil
    local template = nil
    local ownerId = owner:get_id()
    if unitTemplate ~= nil then
        template = unitTemplate
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
    add_unitGroup(ownerId, unitType, unit)
    return unit
end

---@param owner Player
---@param unitType FW.unitMgr.unitType
---@param point? Point 点
---@param direction? number 方向
---@return Unit unit
function unitMgr:createRandomUnit(owner, unitType, point, direction)
    local template = FW.util:randomValueInTable(self.unitTemple[unitType])
    local unit = self:createUnit(owner, unitType, template, nil, point, direction)
    return unit
end

--创建波次小兵，敌方和自己的
---@param unitType FW.unitMgr.unitType
---@param unitSubType FW.unitMgr.enemyUnitType|FW.unitMgr.minioUnitType
---@param count any
function unitMgr:createRoundMinion(unitType, unitSubType, count)
    for index, player in ipairs(FW.playerMgr.allPlayers:pick()) do
        for i = 1, count, 1 do
            local unit
            if unitType == "enemy" then
                unit =  self:createUnit(player, unitType, nil, unitSubType, FW.const.enemyBornPoint[player:get_id()], 0)
                unit:attack_move(FW.const.bornPoint[player:get_id()])
            elseif unitType == "minio" then
                unit =  self:createUnit(player, unitType, nil, unitSubType, FW.const.bornPoint[player:get_id()], 0)
                unit:attack_move(FW.const.enemyBornPoint[player:get_id()])
            end
            unit:add_state("无法控制")
        end
    end
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
