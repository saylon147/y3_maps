local M = {}
function M:gameInit()
    FW.globalVar["gameState"] = FW.const.gameState['gamePrepage']
    FW.playerMgr:initPlayers()
    FW.uiMgr:init()
    self:gameStart()
end

function M:gamePicking()
    FW.globalVar["gameState"] = FW.const.gameState['gamePicking']
end

function M:gameStart()
    y3.timer.loop(60,function (timer,count)
        self:createRandomCrystal()
        if y3.game.current_game_run_time() >= 30 * 60 * 60 then
            timer:remove()
        end
    end,"生成随机水晶",true)
    FW.globalVar["gameState"] = FW.const.gameState['gaming']
    FW.playerMgr:initPlayerUnits()
    y3.player.get_by_id(2):create_unit(134219749)
end

function M:createRandomCrystal()
    for i = 1, 100, 1 do
        local mapArea = y3.area.get_map_area()
        local pointX = y3.math.random_float(mapArea:get_min_x(), mapArea:get_max_x())
        local pointY = y3.math.random_float(mapArea:get_min_y(), mapArea:get_max_y())
        local point = y3.point.create(pointX, pointY)
        local direction = y3.math.random_float(0, 360)
        FW.unitMgr:createUnit(y3.player.get_by_id(31), "scene", "crystal", point, direction)
    end
end

return M
