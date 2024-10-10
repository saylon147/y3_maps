local M = {}
M.uis = {
    --modePanel = require 'scripts.ui.modePanel',
    rolePanel = require 'scripts.ui.rolePanel',
    descPanel = require 'scripts.ui.descPanel'
}
M.showUIs = {
    
}

function M:showUI(uiname)
    M.uis[uiname]:showUI()
end

function M:hideUI(uiname)
    M.uis[uiname]:hideUI()
end

function M:getUI(uiname)
    return M.uis[uiname]
end

function M:init()
    for key, value in pairs(self.uis) do
        value.uiLogic = y3.local_ui.create(value.name)
        value.uiroot = y3.ui.get_ui(y3.player.get_by_id(FW.playerMgr:getLocalPlayerId()),value.name)
    end
    self.uis['rolePanel']:initUI()
    self.uis['descPanel']:initUI()

end

return M