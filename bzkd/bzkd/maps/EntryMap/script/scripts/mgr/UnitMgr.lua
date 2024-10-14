local M = {}
M.unitTemple = {
    enemy = {
        --enemy1 = require 'scripts.unit.enemy.enemy1',
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
    }
}
M.units = {
    enemy = {},
    hero = {},
    scene = {}
}
---@param owner Player|Unit
---@param type string
---@param unitType string
---@param point Point 点
---@param direction number 方向
---@return Unit unit
function M:createUnit(owner, type, unitType, point, direction)
    local unit = self.unitTemple[type][unitType]:create(owner, point, direction)
    table.insert(self.units[type], unit)
    return unit
end

---@param owner Player|Unit
---@param type string
---@param point Point 点
---@param direction number 方向
---@return Unit unit
function M:createRandomUnit(owner, type, point, direction)
    local unit = FW.util:randomValueInTable(self.unitTemple[type]):create(owner, point, direction)
    table.insert(self.units[type], unit)
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
        local unitTemple = FW.util:randomValueInTable(self.unitTemple[type])
        local unit = unitTemple:create(owner, area:random_point(), direction)
        local ori_max_hp = unit:get_attr_base(y3.const.UnitAttr['最大生命'])
        local ori_attack_phy = unit:get_attr_base(y3.const.UnitAttr['物理攻击'])
        unit:add_attr(y3.const.UnitAttr['最大生命'], (FW.gameMgr.currentRound - 1) * ori_max_hp)
        unit:add_attr(y3.const.UnitAttr['物理攻击'], (FW.gameMgr.currentRound - 1) * ori_attack_phy)
        unit:add_attr(y3.const.UnitAttr['最大生命'], (FW.gameMgr.mode - 1) * ori_max_hp)
        unit:add_attr(y3.const.UnitAttr['物理攻击'], (FW.gameMgr.mode - 1) * ori_attack_phy)
        unit:attack_target(enemy, 0)
        table.insert(self.units[type], unit)
    end
end

function M:killAllEnemy()
    for index, value in ipairs(self.units.enemy) do
        value:kill_by(nil)
    end
end

return M
