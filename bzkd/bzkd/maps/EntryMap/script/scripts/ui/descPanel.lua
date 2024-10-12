local M = {}
M.name = '描述面板'
M.uiroot = nil
M.uiLogic = nil

---@type Ability?
local current_ability

---@type Item?
local current_item

---@type UI?
local current_ui

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
    return y3.ui.get_ui(player, self.name)
end

function M:initLogic()
    local rolePanel = FW.uiMgr:getUI('rolePanel')
    for i = 1, 4 do
        local child_name = string.format('英雄技能.%d', i)
        rolePanel.uiLogic:on_event(child_name, '鼠标-移入', function (ui, local_player)
            local selecting_unit = local_player:get_selecting_unit()
            if selecting_unit then
                current_ability = selecting_unit:get_ability_by_slot(y3.const.AbilityType.HERO, i)
            else
                current_ability = nil
            end
            current_ui = ui
            self.uiLogic:refresh('*')
        end)
    
        rolePanel.uiLogic:on_event(child_name, '鼠标-移出', function (ui, local_player)
            current_ability = nil
            current_ui = nil
            self.uiLogic:refresh('*')
        end)
    end
    
    for i = 1, 6 do
        local child_name = string.format('道具.bg%d.%d', i, i)
    
        rolePanel.uiLogic:on_event(child_name, '鼠标-移入', function (ui, local_player)
            local selecting_unit = local_player:get_selecting_unit()
            if selecting_unit then
                current_item = selecting_unit:get_item_by_slot(y3.const.SlotType.BAR, i)
            else
                current_item = nil
            end
            current_ui = ui
            self.uiLogic:refresh('*')
        end)
    
        rolePanel.uiLogic:on_event(child_name, '鼠标-移出', function (ui, local_player)
            current_item = nil
            current_ui = nil
            self.uiLogic:refresh('*')
        end)
    end
    
    self.uiLogic:on_refresh('', function (ui, local_player)
        if (current_ability or current_item) and current_ui then
            ui:set_visible(true)
        else
            ui:set_visible(false)
        end
    end)
    
    self.uiLogic:on_refresh('面板', function (ui, local_player)
        if not current_ui then
            return
        end
        ui:set_absolute_pos(current_ui:get_absolute_x() - 100, current_ui:get_absolute_y() + 100)
    end)
    
    self.uiLogic:on_refresh('面板.标题.图标', function (ui, local_player)
        if current_ability then
            ui:set_image(current_ability:get_icon())
        elseif current_item then
            ui:set_image(current_item:get_icon())
        else
            return
        end
    end)
    
    self.uiLogic:on_refresh('面板.标题.文本', function (ui, local_player)
        if current_ability then
            ui:set_text(current_ability:get_name())
        elseif current_item then
            ui:set_text(current_item:get_name())
        else
            return
        end
    end)
    
    self.uiLogic:on_refresh('面板.描述', function (ui, local_player)
        if current_ability then
            ui:set_text(current_ability:get_description())
        elseif current_item then
            ui:set_text(current_item:get_description())
        else
            return
        end
    end)
end

return M