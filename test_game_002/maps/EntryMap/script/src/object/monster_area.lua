local monster_area = {
    owner = nil,
    config = {},
    time_gap = 5,
    loop = false,
    area = nil,
}

local wave_index = 0
local stopped = false


function monster_area:create(owner, point, area_params)
    self.owner = owner
    self.monsters = y3.unit_group.create()
    self.monster_count = 0

    if area_params["shape"] == y3.area.SHAPE.CIRCLE then
        self.area = y3.area.create_circle_area(point, area_params["r"])
    elseif area_params["shape"] == y3.area.SHAPE.RECTANGLE then
        self.area = y3.area.create_rectangle_area(point, area_params["h"], area_params["v"])
    end
end

function monster_area:add_config(monster_id, count, wave_count)
    count = count or 1
    wave_count = wave_count or 1
    for i = 1, wave_count do
        table.insert(self.config, { id = monster_id, cnt = count })
    end
end

function monster_area:set_time_gap(time_gap)
    self.time_gap = time_gap
end

function monster_area:start(loop)
    stopped = false
    self.loop = loop or false
    y3.timer.loop(self.time_gap, function(timer, count)
        self:next_wave()
    end)
end

function monster_area:next_wave()
    if not self:has_next_wave() or stopped then
        return
    end

    -- TODO 也可以根据monster_count数量再做一次控制

    wave_index = wave_index + 1

    local monster_type = self.config[wave_index].id

    for i = 1, self.config[wave_index].cnt do
        local point = self.area:random_point()
        local monster = y3.unit.create_unit(self.owner, monster_type, point, 0)

        self.monsters:add_unit(monster)
        self.monster_count = self.monster_count + 1

        monster:event("单位-死亡", function(_, data)
            self.monsters:remove_unit(data.unit)
            self.monster_count = self.monster_count - 1
        end)
    end

    if self.loop and wave_index == #self.config then
        wave_index = 0
    end
end

function monster_area:has_next_wave()
    return wave_index < #self.config
end

return monster_area
