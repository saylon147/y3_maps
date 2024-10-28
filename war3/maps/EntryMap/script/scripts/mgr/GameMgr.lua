---@class gameMgr
local gameMgr = Class 'gameMgr'
gameMgr.currentRound = 0
gameMgr.mode = 1
gameMgr.roundTimer = nil
gameMgr.currentGameBrushConfig = nil

function gameMgr:gameInit()
    FW.playerMgr:initPlayers()
    FW.uiMgr:init()
    self:initGlobalEvent()
    self:gamePicking()
end

function gameMgr:gamePicking()
    FW.globalVar.gameState = "gamePrepage"
    local firstPlayer = FW.playerMgr:getFirstPlayer()
    FW.uiMgr:showUI('modePanel', firstPlayer)
    for index, value in pairs(FW.playerMgr.allPlayers:pick()) do
        if value ~= firstPlayer then
            value:display_message('等待玩家' .. firstPlayer:get_name() .. '选择模式')
        end
    end
end

function gameMgr:gameStart()
    FW.globalVar.gameState = "gaming"
    FW.playerMgr:initPlayerSummoner()
    self:gamingEvent()
end

function gameMgr:result()
    FW.globalVar.gameState = "result"
end

function gameMgr:modePicked(args)
    self.mode = args.mode
    self.currentGameBrushConfig = FW.util:deepcopy(FW.configMgr:getConfigTableRowByKey('brushMonster', 'difficulty', self.mode))
    self:gameStart()
end

function gameMgr:update()
end

function gameMgr:initGlobalEvent()
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
end

function gameMgr:gamingEvent()
    y3.timer.loop(1, function(timer, count)
        print('游戏开始后当前时间秒数：' .. count)
        if FW.globalVar.gameState == "gaming" then
            if #self.currentGameBrushConfig > 0 then
                local removes = {}
                for index, config in ipairs(self.currentGameBrushConfig) do
                    if config.time == count then
                        table.insert(removes,config)
                    else 
                        break
                    end
                end
                for i = #removes, 1, -1 do
                    for j = 1, #removes[i].unit_cname, 1 do
                        FW.unitMgr:createRoundMinion(removes[i].unit_type, removes[i].unit_cname[j], removes[i].unit_count[j],removes[i].unit_lv[j])
                    end
                    table.remove(self.currentGameBrushConfig,i)
                end
            end
        end
        if count % 5 == 0 then
            FW.playerMgr:followSummoner()
        end
    end, '刷兵', true)
end

return gameMgr
