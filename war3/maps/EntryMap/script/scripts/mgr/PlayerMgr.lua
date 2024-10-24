---@class playerMgr
local playerMgr = Class 'playerMgr'
---@type PlayerGroup
playerMgr.allPlayers = y3.player_group.create()
playerMgr.maxPlayerCount = 4
playerMgr.maxDeadCount = 3

---@param unit Unit
local function addPlayerUnitEvent(unit)
    unit:event("单位-死亡", function(trg, data)
        local unit = data.unit
        local playerId = unit:get_owner():get_id()
        local deadCount = 0
        if unit:kv_has('deadCount') then
            deadCount = unit:kv_load('deadCount', 'integer')
        end
        unit:kv_save('deadCount', deadCount + 1)
        -- if deadCount ~= nil then
        --     M.playerDeadCount[playerId] = deadCount + 1
        -- else
        --     M.playerDeadCount[playerId] = 1
        -- end
        -- if (M.playerDeadCount[playerId] < M.maxDeadCount) then
        --     y3.ltimer.wait(5, function(timer)
        --         unit:reborn()
        --         data.unit:get_owner():select_unit(unit)
        --         timer:remove()
        --     end)
        -- end
        -- local endGame = true
        -- for key, value in pairs(M.playerDeadCount) do
        --     if value < M.maxDeadCount then
        --         endGame = false
        --         break
        --     end
        -- end
        -- if endGame then
        --     print('游戏结束')
        --     --y3.game.end_player_game(data.unit:get_owner(),'loss',true)
        --     FW.gameMgr:result()
        -- end
    end)
end

local function addPlayerEvent()

end

---@return integer playerId
function playerMgr:getLocalPlayerId()
    local playerid
    y3.player.with_local(function(local_player)
        playerid = local_player:get_id()
    end)
    return playerid
end

---@return Player firstPlayer
function playerMgr:getFirstPlayer()
    for index, value in ipairs(self.allPlayers:pick()) do
        return value
    end
end

function playerMgr:initPlayers()
    for i = 1, self.maxPlayerCount, 1 do
        local player = y3.player.get_by_id(i)
        if player ~= nil and player:get_state() == y3.const.RoleStatus['PLAYING'] then
            playerMgr.allPlayers:add_player(player)
        end
    end
    addPlayerEvent()
end

function playerMgr:initPlayerSummoner()
    for index, player in pairs(FW.playerMgr.allPlayers:pick()) do
        local unit = FW.unitMgr:createUnit(player, 'summoner', nil, 'summoner1', FW.const.bornPoint[player:get_id()])
        addPlayerUnitEvent(unit)
        self:getFollowHero(player)
    end
end

---@param owner Player
function playerMgr:getFollowHero(owner)
    local unit = FW.unitMgr:createRandomUnit(owner, 'followHero')
end

---@param player Player
---@return Unit unit
function playerMgr:getSummonerByPlayer(player)
    return FW.unitMgr.units.summoner[player:get_id()]:get_first()
end

return playerMgr