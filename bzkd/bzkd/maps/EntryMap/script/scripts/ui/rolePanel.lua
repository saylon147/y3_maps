local M = {}
M.name = '角色面板'
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
    return y3.ui.get_ui(player, self.name)
end

function M:initLogic()
    M.uiLogic:bind_unit_attr('头像.属性.攻击速度.文本', '文本', '攻击速度')
    M.uiLogic:bind_unit_attr('头像.属性.移动速度.文本', '文本', '移动速度')
    M.uiLogic:bind_unit_attr('血条.进度条', '当前值', '生命')
    M.uiLogic:bind_unit_attr('血条.进度条', '最大值', '最大生命')
    M.uiLogic:bind_unit_attr('血条.文本.当前值', '文本', '生命')
    M.uiLogic:bind_unit_attr('血条.文本.最大值', '文本', '最大生命')
    M.uiLogic:bind_unit_attr('蓝条.进度条', '当前值', '魔法')
    M.uiLogic:bind_unit_attr('蓝条.进度条', '最大值', '最大魔法')
    M.uiLogic:bind_unit_attr('蓝条.文本.当前值', '文本', '魔法')
    M.uiLogic:bind_unit_attr('蓝条.文本.最大值', '文本', '最大魔法')
    M.uiLogic:bind_unit_attr('属性栏.攻击.文本', '文本', '物理攻击')
    M.uiLogic:bind_unit_attr('属性栏.防御.文本', '文本', '物理防御')
    M.uiLogic:bind_unit_attr('属性栏.力量.文本', '文本', '力量')
    M.uiLogic:bind_unit_attr('属性栏.敏捷.文本', '文本', '敏捷')
    M.uiLogic:bind_unit_attr('属性栏.智力.文本', '文本', '智力')

    M.uiLogic:on_refresh('头像.图片', function(ui, local_player)
        if not local_player:get_selecting_unit() then
            return
        end
        ui:set_image(local_player:get_selecting_unit():get_icon())
    end)

    M.uiLogic:on_refresh('头像.名字.文本', function(ui, local_player)
        if not local_player:get_selecting_unit() then
            return
        end
        ui:set_text(local_player:get_selecting_unit():get_name())
    end)

    M.uiLogic:on_refresh('英雄技能', function(ui, local_player)
        if not local_player:get_selecting_unit() then
            return
        end

        for i, slot in ipairs(ui:get_childs()) do
            local ability = local_player:get_selecting_unit():get_ability_by_slot(y3.const.AbilityType.HERO, i)
            if ability then
                slot:set_visible(true)
                --必须要主动绑定，否则会闪烁一下
                slot:bind_ability(ability)
                if local_player:get_selecting_unit():get_owner() ~= local_player then
                    slot:set_visible(false)
                end
            else
                slot:set_visible(false)
            end
        end
    end)

    M.uiLogic:on_refresh('经验条.进度条', function(ui, local_player)
        if not local_player:get_selecting_unit() then
            return
        end

        ui:set_max_progress_bar_value(local_player:get_selecting_unit():get_upgrade_exp())
        ui:set_current_progress_bar_value(local_player:get_selecting_unit():get_exp())
    end)

    M.uiLogic:on_refresh('经验条.经验文本', function(ui, local_player)
        if not local_player:get_selecting_unit() then
            return
        end

        local exp = local_player:get_selecting_unit():get_exp()
        local max_exp = local_player:get_selecting_unit():get_upgrade_exp()

        if max_exp > 0 then
            ui:set_text(string.format('%d/%d', exp, max_exp))
        else
            ui:set_text('最大')
        end
    end)

    M.uiLogic:on_refresh('经验条.等级文本', function(ui, local_player)
        if not local_player:get_selecting_unit() then
            return
        end

        ui:set_text(string.format('等级%d', local_player:get_selecting_unit():get_level()))
    end)

    M.uiLogic:on_refresh('', function(ui, local_player)
        if local_player:get_selecting_unit() then
            ui:set_visible(true)
        else
            ui:set_visible(false)
        end
    end)

    M.uiLogic:on_event('头像', '左键-按下', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end

        y3.camera.set_camera_follow_unit(local_player, u, 0, 0, 0)
    end)

    M.uiLogic:on_event('头像', '左键-抬起', function(ui, local_player)
        y3.camera.cancel_camera_follow_unit(local_player)
    end)

    y3.game:event('选中-单位', function(trg, data)
        M.uiLogic:refresh('*', data.player)
    end)

    y3.game:event('选中-单位组', function(trg, data)
        M.uiLogic:refresh('*', data.player)
    end)

    y3.game:event('单位-获得经验后', function(trg, data)
        y3.player.with_local(function(local_player)
            if local_player:get_selecting_unit() == data.unit then
                M.uiLogic:refresh('经验条')
            end
        end)
    end)

    y3.game:event('单位-升级', function(trg, data)
        y3.player.with_local(function(local_player)
            if local_player:get_selecting_unit() == data.unit then
                M.uiLogic:refresh('经验条')
            end
        end)
    end)

    y3.game:event('键盘-按下', y3.const.KeyboardKey['SPACE'], function(trg, data)
        local u = data.player:get_selecting_unit()
        if not u then
            return
        end

        y3.camera.set_camera_follow_unit(data.player, u, 0, 0, 0)
    end)

    y3.game:event('键盘-抬起', y3.const.KeyboardKey['SPACE'], function(trg, data)
        y3.camera.cancel_camera_follow_unit(data.player)
    end)

    M.uiLogic:on_refresh('道具', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end

        for i, slot in ipairs(ui:get_childs()) do
            slot:get_child(tostring(i)):set_ui_unit_slot(u, y3.const.SlotType.BAR, i - 1)
            if u:get_owner() ~= local_player then
                slot:set_visible(false)
            else
                slot:set_visible(true)
            end
        end
    end)

    y3.game:event('物品-获得', function(trg, data)
        M.uiLogic:refresh('道具', data.unit:get_owner_player())
    end)
end

return M
