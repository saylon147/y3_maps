local M = {}
M.uiEnum = {
    runtimePanel = 1,
    rolePanel = 2,
    descPanel = 3,
    modePanel = 4,
}
M.uis = {
    [1] = require 'scripts.ui.runtimePanel',
    [2] = require 'scripts.ui.rolePanel',
    [3] = require 'scripts.ui.descPanel',
    [4] = require 'scripts.ui.modePanel'
}
M.showUIs = {
    
}

function M:showUI(uiname,player)
    local index = self.uiEnum[uiname]
    M.uis[index]:showUI(player)
end

function M:hideUI(uiname,player)
    local index = self.uiEnum[uiname]
    M.uis[index]:hideUI(player)
end

function M:getUI(uiname)
    local index = self.uiEnum[uiname]
    return M.uis[index]
end

function M:init()
    for index, value in ipairs(self.uis) do
        value.uiLogic = y3.local_ui.create(value.name)
        value:initUI()
    end
end

return M