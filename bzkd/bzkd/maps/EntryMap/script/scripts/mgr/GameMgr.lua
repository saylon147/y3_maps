local M = {}
M.currentRound = 0
M.mode = 1
M.roundTimer = nil

function M:gameInit()
    FW.globalVar["gameState"] = FW.const.gameState['gamePrepage']
    FW.playerMgr:initPlayers()
    FW.uiMgr:init()
    self:initGlobalEvent()
    self:gamePicking()
end

function M:gamePicking()
    FW.globalVar["gameState"] = FW.const.gameState['gamePicking']
    local firstPlayer = FW.playerMgr:getFirstPlayer()
    FW.uiMgr:showUI('modePanel', firstPlayer)
    for key, value in pairs(FW.playerMgr.allPlayers) do
        if value ~= firstPlayer then
            value:display_message('等待玩家' .. firstPlayer:get_name() .. '选择模式')
        end
    end
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

function M:result()
    self:stopRoundEnemy()
    FW.globalVar["gameState"] = FW.const.gameState.result
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
    self.currentRound = self.currentRound + 1
    y3.timer.loop(FW.const.enemyBornTimeOut, function(timer, count)
        for key, value in pairs(FW.playerMgr.allPlayers) do
            FW.unitMgr:createRandomUnitAtRandomPoint(y3.player.get_by_id(31), "enemy", FW.const.enemyRandomArea[key], 0,
                FW.const.enemyCount, FW.playerMgr:getHeroByPlayer(value))
        end
        if count * FW.const.enemyBornTimeOut >= FW.const.roundTime then
            self.roundTimer = timer
            self:stopRoundEnemy()
        end
    end, '创建轮次敌人', true)
end

function M:stopRoundEnemy()
    if self.roundTimer ~= nil then
        self.roundTimer:remove()
        FW.unitMgr:killAllEnemy()
        local firstPlayer = FW.playerMgr:getFirstPlayer()
        for key, value in pairs(FW.playerMgr.allPlayers) do
            if value == firstPlayer then
                FW.uiMgr:getUI('runtimePanel'):showOrHideNextRound(true, firstPlayer)
            else
                value:display_message('等待玩家' .. firstPlayer:get_name() .. '点击进入下一轮')
            end
        end
    end
end

function M:modePicked(args)
    self.mode = args.mode
    self:gameStart()
end

local function movePlayer(key, value, player)
    local lastH = player:kv_load('h', 'integer') or 0
    local lastV = player:kv_load('v', 'integer') or 0
    if key == 'h' then
        lastH = lastH + value
    else
        lastV = lastV + value
    end
    player:kv_save('h', lastH)
    player:kv_save('v', lastV)
    local hero = FW.playerMgr:getHeroByPlayer(player)
    local oriPoint = hero:get_point()
    local point
    if lastH == 0 and lastV == 0 then
        hero:stop()
        return
    end
    local angle = 0
    if lastH > 0 then
        angle = 90
        if lastV > 0 then
            angle = 45
        elseif lastV < 0 then
            angle = 135
        end
        
    elseif lastH < 0 then
        angle = 270
        if lastV > 0 then
            angle = 315
        elseif lastV < 0 then
            angle = 225
        end
    else
        if lastV > 0 then
            angle = 0
        elseif lastV < 0 then
            angle = 180
        end
    end
    point = y3.point.get_point_offset_vector(oriPoint, angle, 3000)
    hero:move_to_pos(point)
end

function M:update()

end

function M:initGlobalEvent()
    --只能调用FW下的方法
    y3.sync.onSync('异步调用同步方法', function(data, source)
        ---@cast data table
        local str = data.func
        local args = data.args
        local t = FW.util:strToTable(str, ".")
        FW[t[1]][t[2]](FW[t[1]], args)
    end)
    y3.ltimer.loop_frame(1, function(timer, count)
        self:update()
    end)
    y3.game:event('本地-键盘-按下', y3.const.KeyboardKey['W'], function(trg, data)
        if FW.globalVar["gameState"] ~= FW.const.gameState.gaming then
            return
        end
        movePlayer('v', -1, data.player)
    end)
    y3.game:event('本地-键盘-按下', y3.const.KeyboardKey['A'], function(trg, data)
        if FW.globalVar["gameState"] ~= FW.const.gameState.gaming then
            return
        end
        movePlayer('h', -1, data.player)
    end)
    y3.game:event('本地-键盘-按下', y3.const.KeyboardKey['S'], function(trg, data)
        if FW.globalVar["gameState"] ~= FW.const.gameState.gaming then
            return
        end
        movePlayer('v', 1, data.player)
    end)
    y3.game:event('本地-键盘-按下', y3.const.KeyboardKey['D'], function(trg, data)
        if FW.globalVar["gameState"] ~= FW.const.gameState.gaming then
            return
        end
        movePlayer('h', 1, data.player)
    end)

    y3.game:event('本地-键盘-抬起', y3.const.KeyboardKey['W'], function(trg, data)
        if FW.globalVar["gameState"] ~= FW.const.gameState.gaming then
            return
        end
        movePlayer('v', 1, data.player)
    end)
    y3.game:event('本地-键盘-抬起', y3.const.KeyboardKey['A'], function(trg, data)
        if FW.globalVar["gameState"] ~= FW.const.gameState.gaming then
            return
        end
        movePlayer('h', 1, data.player)
    end)
    y3.game:event('本地-键盘-抬起', y3.const.KeyboardKey['S'], function(trg, data)
        if FW.globalVar["gameState"] ~= FW.const.gameState.gaming then
            return
        end
        movePlayer('v', -1, data.player)
    end)
    y3.game:event('本地-键盘-抬起', y3.const.KeyboardKey['D'], function(trg, data)
        if FW.globalVar["gameState"] ~= FW.const.gameState.gaming then
            return
        end
        movePlayer('h', -1, data.player)
    end)
end

return M
