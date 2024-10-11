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
    -- y3.timer.loop(60,function (timer,count)
    --     self:createRandomCrystal()
    --     if y3.game.current_game_run_time() >= 30 * 60 * 60 then
    --         timer:remove()
    --     end
    -- end,"生成随机水晶",true)
    FW.globalVar["gameState"] = FW.const.gameState['gaming']
    FW.playerMgr:initPlayerUnits()
    self:roundEnemy()
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

function M:roundEnemy()
    y3.timer.loop(FW.const.enemyBornTimeOut,function (timer,count)
        if count * FW.const.enemyBornTimeOut >= FW.const.roundTime then
            timer:remove()
        end
        for key, value in pairs(FW.playerMgr.allPlayers) do
            FW.unitMgr:createRandomUnitAtRandomPoint(y3.player.get_by_id(31),"enemy",FW.const.enemyRandomArea[key],0,FW.const.enemyCount,FW.playerMgr:getHeroByPlayer(value))
        end
    end)
end

return M
