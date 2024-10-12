local M = {}
M.name = '模式选择'
M.uiLogic = nil
function M:initUI()
    self:initLogic()
    self:hideUI()
end

function M:showUI(player)
    player = player or nil
    if player ~= nil then
        self:getUIByPlayer(player):set_visible(true)
    else
        local local_playerId = FW.playerMgr:getLocalPlayerId()
        local local_player = FW.playerMgr.allPlayers[local_playerId]
        self:getUIByPlayer(local_player):set_visible(true)
    end 
end

function M:hideUI(player)
    player = player or nil
    if player ~= nil then
        self:getUIByPlayer(player):set_visible(false)
    else
        local local_playerId = FW.playerMgr:getLocalPlayerId()
        local local_player = FW.playerMgr.allPlayers[local_playerId]
        self:getUIByPlayer(local_player):set_visible(false)
    end
end

function M:getUIByPlayer(player)
    player = player or nil
    if player == nil then
        local local_playerId = FW.playerMgr:getLocalPlayerId()
        player = FW.playerMgr.allPlayers[local_playerId]
    end
    return y3.ui.get_ui(player, self.name)
end

function M:initLogic()
    self.uiLogic:on_event('mode1', '左键-按下', function(ui, local_player)
        ui:get_parent():set_visible(false)
        local data = {}
        data.args = {mode = 1}
        data.func = 'gameMgr.modePicked'
        y3.sync.send('异步调用同步方法',data)
    end)
    self.uiLogic:on_event('mode2', '左键-按下', function(ui, local_player)
        ui:get_parent():set_visible(false)
        local data = {}
        data.args = {mode = 2}
        data.func = 'gameMgr.modePicked'
        y3.sync.send('异步调用同步方法',data)
    end)
end

return M
