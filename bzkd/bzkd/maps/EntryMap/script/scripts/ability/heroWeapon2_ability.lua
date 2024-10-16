local skill = y3.object.ability[134230019]
skill:event('施法-开始', function(trg, data)
    local unit = data.unit
    unit:play_animation('attack1', unit:get_attr("攻击速度") / 100)
end)
skill:event('施法-引导', function(trg, data)
    local projectileData = {
        key = 134275600,
        owner = data.unit,
        target = data.unit,
        socket = 'attack1'
    }
    local projectile = y3.projectile.create(projectileData)
    projectile:set_facing(data.unit:get_facing())
    local moverData = {
        target = data.unit,
        radius = 0,
        init_angle = data.unit:get_facing(),
        on_finish = function()
            projectile:remove()
        end
    }
    projectile:mover_round(moverData)
end)
skill:event('施法-出手', function(trg, data)
    local direction = data.unit:get_facing()
    local shape = y3.shape.create_sector_shape(500, 20, direction)
    y3.ltimer.loop_count(0.2, 10, function(timer, count)
        if count >= 10 then
            timer:remove()
            data.unit:stop_animation('attack1')
        end
        local point = data.unit:get_point()
        local selector = y3.selector:in_shape(point, shape)
        for index, value in selector:ipairs() do
            if value:is_enemy(data.unit) then
                local damageData = {
                    target = value,
                    type = y3.const.DamageTypeMap['物理'],
                    damage = data.unit:get_attr(y3.const.UnitAttr['物理攻击']),
                    text_type = 'physics',
                    socket = 'hit_point'
                }
                data.unit:damage(damageData)
            end
        end
    end)
end)