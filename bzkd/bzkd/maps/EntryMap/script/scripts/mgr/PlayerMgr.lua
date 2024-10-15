local M = {}
M.allPlayers = {}
M.allPlayerIds = {}
M.maxPlayerCount = 4
M.playerDeadCount = {}
M.maxDeadCount = 3

---@param unit Unit
local function addPlayerUnitEvent(unit)
    unit:event("单位-死亡", function(trg, data)
        local playerId = data.unit:get_owner():get_id()
        local deadCount = M.playerDeadCount[playerId]
        if deadCount ~= nil then
            M.playerDeadCount[playerId] = deadCount + 1
        else
            M.playerDeadCount[playerId] = 1
        end
        if (M.playerDeadCount[playerId] < M.maxDeadCount) then
            y3.ltimer.wait(5, function(timer)
                unit:reborn()
                timer:remove()
            end)
        end
        local endGame = true
        for key, value in pairs(M.playerDeadCount) do
            if value < M.maxDeadCount then
                endGame = false
                break
            end
        end
        if endGame then
            print('游戏结束')
            FW.gameMgr:result()
        end
    end)
end

function M:getLocalPlayerId()
    local playerid
    y3.player.with_local(function(local_player)
        playerid = local_player:get_id()
    end)
    return playerid
end

function M:getFirstPlayer()
    table.sort(self.allPlayerIds)
    for index, value in ipairs(self.allPlayerIds) do
        return self.allPlayers[value]
    end
end

---@param player Player
function M:addPlayer(player)
    self.allPlayers[player:get_id()] = player
    table.insert(self.allPlayerIds, player:get_id())
end

function M:initPlayers()
    for i = 1, self.maxPlayerCount, 1 do
        if y3.player.get_by_id(i):get_state() == 1 then
            self:addPlayer(y3.player.get_by_id(i))
        end
    end
end

function M:initPlayerUnits()
    for key, value in pairs(self.allPlayers) do
        local unit = FW.unitMgr:createRandomUnit(value, 'hero', FW.const.bornPoint[key], 0)
        FW.unitMgr:createRandomUnit(value, 'heroWeapon', unit:get_point(), FW.const.heroWeaponAngle[1])
        FW.unitMgr:createRandomUnit(value, 'heroWeapon', unit:get_point(), FW.const.heroWeaponAngle[2])
        addPlayerUnitEvent(unit)
        local camera = FW.const.playerCamera[key]
        camera.set_camera_follow_unit(value, unit)
    end
end

function M:getHeroByPlayer(player)
    return FW.unitMgr.units.hero[player:get_id()]:get_first()
end

return M
