local M = {}
M.id = 134245544
M.template = y3.object.unit[M.id] --物编信息

local function addAbilitys(unit)
    unit:add_ability('普通',134235512)
end

---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    local unit = y3.unit.create_unit(owner, self.id, point, direction)
    unit:add_state('无法控制')
    unit:add_state('无法被选中')
    unit:add_state('无法被攻击')
    unit:add_state("无视静态碰撞")
    unit:add_state("无视动态碰撞")
    unit:add_state("禁止转向")
    addAbilitys(unit)
    local mover_data = {
        target = FW.playerMgr:getHeroByPlayer(owner),
        radius = 200,
        init_angle = direction,
        height = 30,
    }
    unit:mover_round(mover_data)
    return unit
end
return M