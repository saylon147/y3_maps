---@class playerMgr
local playerMgr = Class 'playerMgr'
---@type PlayerGroup
playerMgr.allPlayers = y3.player_group.create()
playerMgr.maxPlayerCount = 4
playerMgr.maxDeadCount = 3

-- ---@param unit Unit
-- local function addPlayerUnitEvent(unit)
--     unit:event("单位-死亡", function(trg, data)
--         local playerId = data.unit:get_owner():get_id()
--         local deadCount = M.playerDeadCount[playerId]
--         if deadCount ~= nil then
--             M.playerDeadCount[playerId] = deadCount + 1
--         else
--             M.playerDeadCount[playerId] = 1
--         end
--         if (M.playerDeadCount[playerId] < M.maxDeadCount) then
--             y3.ltimer.wait(5, function(timer)
--                 unit:reborn()
--                 data.unit:get_owner():select_unit(unit)
--                 timer:remove()
--             end)
--         end
--         local endGame = true
--         for key, value in pairs(M.playerDeadCount) do
--             if value < M.maxDeadCount then
--                 endGame = false
--                 break
--             end
--         end
--         if endGame then
--             print('游戏结束')
--             --y3.game.end_player_game(data.unit:get_owner(),'loss',true)
--             FW.gameMgr:result()
--         end
--     end)
-- end

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

function playerMgr:initPlayerSummoners()
    for index, player in pairs(FW.playerMgr.allPlayers:pick()) do
        
    end


    -- for key, value in pairs(self.allPlayers) do
    --     local unit = FW.unitMgr:createRandomUnit(value, 'hero', FW.const.bornPoint[key], 0)
    --     unit:set_select_effect_visible(false)
    --     value:select_unit(unit)
    --     FW.unitMgr:createRandomHeroWeapon({key, unit})
    --     addPlayerUnitEvent(unit)
    --     local camera = FW.const.playerCamera[key]
    --     camera.set_camera_follow_unit(value, unit)
    -- end
end

-- ---@param player Player
-- ---@return Unit unit
-- function M:getHeroByPlayer(player)
--     return FW.unitMgr.units.hero[player:get_id()]:get_first()
-- end
return playerMgr
