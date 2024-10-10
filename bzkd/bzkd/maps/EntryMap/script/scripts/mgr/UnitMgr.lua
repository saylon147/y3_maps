local M = {}
M.unitTemple = {
    enemy = {},
    hero = {},
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
function M:createUnit(owner,type,unitType,point,direction)
    local unit = self.unitTemple[type][unitType]:create(owner,point,direction)
    table.insert(self.units.scene,unit)
end
return M