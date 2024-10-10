local M = {}
M.allPlayers={}
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
        if y3.player.get_by_id(i) ~= nil then
            self:addPlayer(y3.player.get_by_id(i))
        end
    end
end

return M
