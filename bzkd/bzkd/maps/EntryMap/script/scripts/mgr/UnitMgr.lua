local M = {}
M.unitTemple = {
    enemy = {
        enemy1 = require 'scripts.unit.enemy.enemy1',
        enemy2 = require 'scripts.unit.enemy.enemy2',
        enemy3 = require 'scripts.unit.enemy.enemy3'
    },
    hero = {
        hero1 = require 'scripts.unit.hero.hero1',
        hero2 = require 'scripts.unit.hero.hero2',
        hero3 = require 'scripts.unit.hero.hero3',
    },
    scene = {
        crystal = require 'scripts.unit.scene.crystal'
    },
    heroWeapon = {
        heroWeapon1 = require 'scripts.unit.heroWeapon.heroWeapon1',
        heroWeapon2 = require 'scripts.unit.heroWeapon.heroWeapon2'
    },
    pickUnit = {
        exp = require 'scripts.unit.pickUnit.exp',
        gold = require 'scripts.unit.pickUnit.gold',
        health = require 'scripts.unit.pickUnit.health'
    }

}
M.units = {
    enemy = {},
    hero = {},
    scene = {},
    heroWeapon = {},
    pickUnit = {}
}
local function add_unitGroup(owner, type, unit, point)
    local id = FW.playerMgr:getPlayerIdByPoint(owner, point)
    if M.units[type][id] == nil then
        M.units[type][id] = y3.unit_group.create()
    end
    M.units[type][id]:add_unit(unit)
end

---@param owner Player|Unit
---@param type string
---@param unitType string
---@param point Point 点
---@param direction? number 方向
---@return Unit unit
function M:createUnit(owner, type, unitType, point, direction)
    direction = direction or 0
    local template = self.unitTemple[type][unitType]
    local unit = template:create(owner, point, direction)
    unit:kv_save('template', template)
    add_unitGroup(owner, type, unit, point)
    return unit
end

---@param owner Player|Unit
---@param type string
---@param point Point 点
---@param direction? number 方向
---@return Unit unit
function M:createRandomUnit(owner, type, point, direction)
    direction = direction or 0
    local template = FW.util:randomValueInTable(self.unitTemple[type])
    local unit = template:create(owner, point, direction)
    unit:kv_save('template', template)
    add_unitGroup(owner, type, unit, point)
    return unit
end

---@param owner Player|Unit
---@param type string
---@param area Area
---@param direction number 方向
---@param count number 数量
---@param enemy Player|Unit
function M:createRandomUnitAtRandomPoint(owner, type, area, direction, count, enemy)
    for i = 1, count, 1 do
        local template = FW.util:randomValueInTable(self.unitTemple[type])
        local point = area:random_point()
        local unit = template:create(owner, point, direction)
        unit:kv_save('template', template)
        local ori_max_hp = unit:get_attr_base(y3.const.UnitAttr['最大生命'])
        local ori_attack_phy = unit:get_attr_base(y3.const.UnitAttr['物理攻击'])
        unit:add_attr(y3.const.UnitAttr['最大生命'], (FW.gameMgr.currentRound - 1) * ori_max_hp)
        unit:add_attr(y3.const.UnitAttr['物理攻击'], (FW.gameMgr.currentRound - 1) * ori_attack_phy)
        unit:add_attr(y3.const.UnitAttr['最大生命'], (FW.gameMgr.mode - 1) * ori_max_hp)
        unit:add_attr(y3.const.UnitAttr['物理攻击'], (FW.gameMgr.mode - 1) * ori_attack_phy)
        unit:attack_target(enemy, 0)
        add_unitGroup(owner, type, unit, point)
    end
end

function M:createRandomHeroWeapon(ownerId, heroUnit)
    if heroUnit == nil then
        return
    end
    local count
    if self.units.heroWeapon[ownerId] == nil then
        count = 0
    else
        count = self.units.heroWeapon[ownerId]:count()
    end
    if count >= FW.const.maxHeroWeaponCount then
        return
    end
    local point = y3.point.create(0, 0, 0)
    local player = y3.player.get_by_id(ownerId)
    local template = FW.util:randomValueInTable(self.unitTemple['heroWeapon'])
    local unit = template:create(player, point, 0)
    count = count + 1
    unit:kv_save('template', template)
    add_unitGroup(player, 'heroWeapon', unit, point)
    local perAngle = 360 / count
    for index, value in ipairs(self.units.heroWeapon[ownerId]:pick()) do
        if value:kv_has('template') then
            local angle = (index - 1) * perAngle
            local template = value:kv_load('template', 'table')
            template:refreshMover(value, heroUnit, angle)
            value:set_facing(angle, 0)
        end
    end
end

function M:killAllEnemyByPlayerId(playerId)
    local enemyGroup = self.units.enemy[playerId]
    for index, value in ipairs(enemyGroup:pick()) do
        value:kill_by(nil)
    end
    enemyGroup:clear()
end

function M:killAllEnemy()
    for key, value in pairs(self.units.enemy) do
        self:killAllEnemyByPlayerId(key)
    end
end

function M:roundGetPickUnit()
    for key, pickUnitGroup in pairs(self.units.pickUnit) do
        local hero = FW.playerMgr:getHeroByPlayer(y3.player.get_by_id(key))
        for index, value in ipairs(pickUnitGroup:pick()) do
            self:moveToUnit(value, hero)
        end
    end
end

---@param unit Unit
---@param target Unit
function M:moveToUnit(unit, target)
    if unit:has_tag('picked') then
        return
    end
    local moverData = {
        target = target,
        speed = 1000,
        target_distance = 0,
        parabola_height = 100,
        on_finish = function()
            local player = target:get_owner()
            if unit:kv_has('gold') then
                local gold = player:get_attr('gold') + unit:kv_load('gold','number')
                player:set('gold', gold)
            end
            if unit:kv_has('exp') then
                target:add_exp(unit:kv_load('exp','number'))
            end
            if unit:kv_has('health') then
                target:add_hp(unit:kv_load('health','number'))
            end
            self.units.pickUnit[player:get_id()]:remove_unit(unit)
            unit:remove()
        end
    }
    unit:mover_target(moverData)
    unit:add_tag('picked')
end

return M
