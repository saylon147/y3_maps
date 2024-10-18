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
            --y3.game.end_player_game(data.unit:get_owner(),'loss',true)
            FW.gameMgr:result()
        end
    end)
end

local function movePlayer(key, value, player)
    local hero = M:getHeroByPlayer(player)
    if FW.globalVar["gameState"] ~= FW.const.gameState.gaming or not hero:has_state("无法控制") then
        return
    end
    player:kv_save(key, value)
    local lastW = player:kv_load('w', 'integer') or 0
    local lastA = player:kv_load('a', 'integer') or 0
    local lastS = player:kv_load('s', 'integer') or 0
    local lastD = player:kv_load('d', 'integer') or 0
    local h = lastA + lastD
    local v = lastW + lastS
    local oriPoint = hero:get_point()
    local point
    if h == 0 and v == 0 then
        hero:stop()
        return
    end
    local angle = 0
    if h > 0 then
        angle = 90
        if v > 0 then
            angle = 45
        elseif v < 0 then
            angle = 135
        end
    elseif h < 0 then
        angle = 270
        if v > 0 then
            angle = 315
        elseif v < 0 then
            angle = 225
        end
    else
        if v > 0 then
            angle = 0
        elseif v < 0 then
            angle = 180
        end
    end
    point = y3.point.get_point_offset_vector(oriPoint, angle, 3000)
    local area = FW.const.enemyRandomArea[player:get_id()]
    local maxX = area:get_max_x() - 50
    local minX = area:get_min_x() + 50
    local maxY = area:get_max_y() - 50
    local minY = area:get_min_y() + 50
    point = y3.point.create(FW.util:clamp(point:get_x(), minX, maxX), FW.util:clamp(point:get_y(), minY, maxY),
        point:get_z())
    hero:move_to_pos(point)
end

---@param player Player
local function addPlayerEvent(player)
    player:event('本地-键盘-按下', y3.const.KeyboardKey['W'], function(trg, data)
        movePlayer('w', -1, data.player)
    end)
    player:event('本地-键盘-按下', y3.const.KeyboardKey['A'], function(trg, data)
        movePlayer('a', -1, data.player)
    end)
    player:event('本地-键盘-按下', y3.const.KeyboardKey['S'], function(trg, data)
        movePlayer('s', 1, data.player)
    end)
    player:event('本地-键盘-按下', y3.const.KeyboardKey['D'], function(trg, data)
        movePlayer('d', 1, data.player)
    end)

    player:event('本地-键盘-抬起', y3.const.KeyboardKey['W'], function(trg, data)
        movePlayer('w', 0, data.player)
    end)
    player:event('本地-键盘-抬起', y3.const.KeyboardKey['A'], function(trg, data)
        movePlayer('a', 0, data.player)
    end)
    player:event('本地-键盘-抬起', y3.const.KeyboardKey['S'], function(trg, data)
        movePlayer('s', 0, data.player)
    end)
    player:event('本地-键盘-抬起', y3.const.KeyboardKey['D'], function(trg, data)
        movePlayer('d', 0, data.player)
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
    player:set_mouse_click_selection(false)
    player:set_mouse_drag_selection(false)
    addPlayerEvent(player)
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
        unit:set_select_effect_visible(false)
        value:select_unit(unit)
        FW.unitMgr:createRandomHeroWeapon(key, unit)
        addPlayerUnitEvent(unit)
        local camera = FW.const.playerCamera[key]
        camera.set_camera_follow_unit(value, unit)
    end
end

---@param player Player
---@return Unit unit
function M:getHeroByPlayer(player)
    return FW.unitMgr.units.hero[player:get_id()]:get_first()
end

---@param player Player
---@param point Point
---@return integer id
function M:getPlayerIdByPoint(player,point)
    local id
    if player:get_id() > FW.playerMgr.maxPlayerCount then
        for index, value in ipairs(FW.const.enemyRandomArea) do
            if value:is_point_in_area(point) then
                id = index
            end
        end
    else
        id = player:get_id()
    end
    return id
end

return M
