local skill = y3.object.ability[134254150]
skill:event('施法-出手', function(trg, data)
    local unit = data.unit
    local owner = unit:get_owner()
    local direction = unit:get_facing()
    local shape = y3.shape.create_sector_shape(500, 90, direction)
    local point = unit:get_point()
    local selector = y3.selector:in_shape(point, shape):is_enemy(owner):sort_type("由近到远"):count(1)
    for index, target in selector:ipairs() do
        unit:remove_mover()
        unit:play_animation('attack1', unit:get_attr("攻击速度") / 100)
        local moverData = {
            target = target,
            speed = 1000,
            target_distance = 0,
            parabola_height = 100,
            on_finish = function()
                local damageData = {
                    target = target,
                    type = y3.const.DamageTypeMap['物理'],
                    damage = data.unit:get_attr(y3.const.UnitAttr['物理攻击']),
                    text_type = 'physics',
                    socket = 'hit_point'
                }
                data.unit:damage(damageData)
                unit:remove_mover()
                FW.unitMgr:refreshHeroWeapon(unit,FW.playerMgr:getHeroByPlayer(owner))
                unit:stop_animation('attack1')
            end
        }
        unit:mover_target(moverData)
        
    end
end)
