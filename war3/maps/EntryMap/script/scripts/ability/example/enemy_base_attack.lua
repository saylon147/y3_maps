local skill = y3.object.ability[134235512]
skill:event('施法-开始', function(trg, data)
    local unit = data.unit
    unit:play_animation('attack1', unit:get_attr("攻击速度") / 100)
end)
skill:event('施法-引导', function(trg, data)
    local projectileData = {
        key = 134271660,
        owner = data.unit,
        target = data.unit,
        socket = 'attack1'
    }
    local projectile = y3.projectile.create(projectileData)
    -- local moverData = {
    --     target = data.ability_target_unit,
    --     speed = 1000,
    --     target_distance = 100,
    --     height = 50
    -- }
    -- y3.mover.mover_target(projectile,moverData)
    local moverData = {
        hit_type = 0,
        hit_radius = 1,
        hit_same = false,
        terrain_block = true,
        angle = data.unit:get_facing(),
        distance = 3000,
        speed = 1000,
        on_finish = function()
            projectile:remove()
        end,
        on_hit = function(mover, unit)
            if unit:has_state('无法被攻击') then
                return
            end
            local damageData = {
                target = unit,
                type = y3.const.DamageTypeMap['物理'],
                damage = data.unit:get_attr(y3.const.UnitAttr['物理攻击']),
                text_type = 'physics',
                socket = 'hit_point'
            }
            data.unit:damage(damageData)
            projectile:remove()
        end,
        on_block = function ()
            projectile:remove()
        end
    }
    projectile:mover_line(moverData)
end)
skill:event('施法-结束', function(trg, data)
    local unit = data.unit
    unit:stop_animation('attack1')
end)
