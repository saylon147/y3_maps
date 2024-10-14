local M = {}
M.allPlayers = {}
M.allPlayerIds = {}
M.maxPlayerCount = 4
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
        local camera = FW.const.playerCamera[key]
        camera.set_camera_follow_unit(value, unit)
    end
end

function M:getHeroByPlayer(player)
    local unit
    for key, value in pairs(FW.unitMgr.units['hero']) do
        if value:get_owner() == player then
            unit = value
            break
        end
    end
    return unit
end

return M
