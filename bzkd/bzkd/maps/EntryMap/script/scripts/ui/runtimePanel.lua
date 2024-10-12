local M = {}
M.name = 'Runtime'
M.uiLogic = nil
function M:initUI()
    self:initLogic()
    self:showUI()
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

function M:showOrHideNextRound(show,player)
    self:getUIByPlayer(player):get_child('nextround'):set_visible(show)
end

function M:initLogic()
    self:showOrHideNextRound(false)
    self.uiLogic:on_event('nextround', '左键-按下', function(ui, local_player)
        ui:set_visible(false)
        local data = {}
        data.func = 'gameMgr.roundEnemy'
        y3.sync.send('异步调用同步方法',data)
    end)
end

return M
