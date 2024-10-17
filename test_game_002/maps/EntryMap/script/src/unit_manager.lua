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
    -- local unit = y3.unit.create_unit(owner, 134219010, y3.point.create(0, 0, 0), 180.0)
    local unit = nil
    if type == "HERO" then
        unit = y3.unit.create_unit(owner, id, point, direction)
    end
    return unit
end

return UnitManager
