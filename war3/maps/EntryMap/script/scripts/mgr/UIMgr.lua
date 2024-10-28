---@class uiMgr
local uiMgr = Class 'uiMgr'
---@enum(key) FW.uiMgr.uiEnum
uiMgr.uiEnum = {
    modePanel = require 'scripts.ui.modePanel',
    hudPanel = require 'scripts.ui.hudPanel'
}

---@param uiKey FW.uiMgr.uiEnum
---@param player Player?
---@return UI ui
function uiMgr:getUIByPlayer(uiKey,player)
    player = player or nil
    if player == nil then
        local local_playerId = FW.playerMgr:getLocalPlayerId()
        player = y3.player.get_by_id(local_playerId)
    end
    return y3.ui.get_ui(player, self:getUITemplate(uiKey).name)
end

---@param uiKey FW.uiMgr.uiEnum
---@param player Player?
function uiMgr:showUI(uiKey,player)
    self:getUIByPlayer(uiKey,player):set_visible(true)
    self:getUITemplate(uiKey):showUI(player)
end

---@param uiKey FW.uiMgr.uiEnum
---@param player Player?
function uiMgr:hideUI(uiKey,player)
    self:getUIByPlayer(uiKey,player):set_visible(false)
    self:getUITemplate(uiKey):hideUI(player)
end

---@param uiKey FW.uiMgr.uiEnum
---@return table uiTemplate
function uiMgr:getUITemplate(uiKey)
    return self.uiEnum[uiKey]
end

function uiMgr:init()
    for key, uiTemplate in pairs(self.uiEnum) do
        uiTemplate.uiLogic = y3.local_ui.create(uiTemplate.name)
        self:hideUI(key)
        uiTemplate:initUI()
    end
end

return uiMgr