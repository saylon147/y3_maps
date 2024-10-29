---@class modePanel
local modePanel = Class 'modePanel'
modePanel.name = '模式选择'
---@type LocalUILogic
modePanel.uiLogic = nil
modePanel.type = 'uiTemplate'
function modePanel:initUI()
    self:initLogic()
end

---@param player Player?
function modePanel:showUI(player)
     
end

---@param player Player?
function modePanel:hideUI(player)
    
end

function modePanel:initLogic()
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

return modePanel
