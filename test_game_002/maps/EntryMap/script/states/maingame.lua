local maingame = {}

function maingame:enter()
    print("进入 MAINGAME")

    -- 创建主角
    local hero = y3.player(1):create_unit(134219010, y3.point.create(0, 0, 0), 180.0)

    -- 创建刷怪点
    local building = y3.unit.create_unit(y3.player(31), 134237546, y3.point.create(-1000, -1000, 0), 0.0)
end

function maingame:update()

end

function maingame:exit()

end

return maingame
