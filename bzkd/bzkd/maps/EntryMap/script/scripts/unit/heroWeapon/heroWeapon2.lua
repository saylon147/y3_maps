local M = {}
M.id = 134237519
M.template = y3.object.unit[M.id] --物编信息

local function addAbilitys(unit)
    unit:add_ability('普通',134230019)
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
    addAbilitys(unit)
    return unit
end
---@param unit Player|Unit
---@param target Player|Unit
---@param angle number 方向
function M:refreshMover(unit,target,angle)
    unit:remove_mover()
    local mover_data = {
        target = target,
        radius = 200,
        init_angle = angle,
        height = 30,
    }
    unit:mover_round(mover_data)
end
return M