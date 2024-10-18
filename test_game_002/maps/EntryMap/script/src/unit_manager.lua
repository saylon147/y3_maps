---
UnitManager = {
    -- 英雄单位
    hero_id = {
        134219010,
        134270560,
    },

    -- 怪物单位

    -- 其他单位

}


function UnitManager:create_unit(owner, type, id, point, direction)
    if type == "HERO" then
        return y3.unit.create_unit(owner, id, point, direction)
    elseif type == "MONSTER" then
        return y3.unit.create_unit(owner, id, point, direction)
    else
        return y3.unit.create_unit(owner, id, point, direction)
    end
end

function UnitManager:remove_all_unit(owner)
    local units = owner:get_all_units()
    for _, v in ipairs(units:pick()) do
        v:remove()
    end
    units:clear()
end

return UnitManager
