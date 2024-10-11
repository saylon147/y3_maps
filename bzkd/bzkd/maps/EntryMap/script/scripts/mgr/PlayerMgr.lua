local M = {}
M.allPlayers = {}
M.maxPlayerCount = 4
function M:getLocalPlayerId()
    local playerid
    y3.player.with_local(function(local_player)
        playerid = local_player:get_id()
    end)
    return playerid
end

---@param player Player
function M:addPlayer(player)
    M.allPlayers[player:get_id()] = player
end

function M:initPlayers()
    for i = 1, self.maxPlayerCount, 1 do
        if y3.player.get_by_id(i):get_state() == 1 then
            self:addPlayer(y3.player.get_by_id(i))
        end
    end
end

function M:initPlayerUnits()
    for index, value in ipairs(self.allPlayers) do
        local unit = FW.unitMgr:createRandomUnit(value, 'hero', FW.const.bornPoint[index], 0)
        unit:set_attr(y3.const.UnitAttr['最大生命'], 500000)
        local camera = FW.const.playerCamera[index]
        camera.set_camera_follow_unit(value, unit)
    end
end

function M:getHeroByPlayer(player)
    local unit
    for index, value in ipairs(FW.unitMgr.units['hero']) do
        if value:get_owner() == player then
            unit = value
            break
        end
    end
    return unit
end

return M
