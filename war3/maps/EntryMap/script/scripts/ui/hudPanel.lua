---@class hudPanel
local hudPanel = Class 'hudPanel'
hudPanel.name = 'War3HUD'
---@type LocalUILogic
hudPanel.uiLogic = nil
hudPanel.type = 'uiTemplate'
function hudPanel:initUI()
    self:initLogic()
    FW.uiMgr:showUI("hudPanel")
end

---@param player Player?
function hudPanel:showUI(player)

end

---@param player Player?
function hudPanel:hideUI(player)

end

function hudPanel:initLogic()
    self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.英雄.护甲.攻击力.护甲值', '文本', '物理防御')
    self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.英雄.力量.力量值', '文本', '力量')
    self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.英雄.敏捷.敏捷值', '文本', '敏捷')
    self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.英雄.智力.智力值', '文本', '智力')
    --更新名称
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.英雄.等级经验条.单位名', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            ui:set_text(unit:get_name())
        end
    end)
    --更新等级条文本
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.英雄.等级经验条.等级说明', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            ui:set_text(string.format('等级%d %s', unit:get_level(), unit:get_name()))
        end
    end)
    --更新经验条
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.英雄.等级经验条', function(ui, local_player)
        if not local_player:get_selecting_unit() then
            return
        end

        ui:set_max_progress_bar_value(local_player:get_selecting_unit():get_upgrade_exp())
        ui:set_current_progress_bar_value(local_player:get_selecting_unit():get_exp())
    end)

    --更新血量
    self.uiLogic:on_refresh('HUD.Console.Data.left.血量', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            ui:set_text(math.ceil(unit:get_hp()) .. '  /  ' .. math.ceil(unit:get_attr("最大生命")))
        end
    end)

    --更新蓝量
    self.uiLogic:on_refresh('HUD.Console.Data.left.蓝量', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            ui:set_text(math.ceil(unit:get_mp()) .. '  /  ' .. math.ceil(unit:get_attr('最大魔法')))
        end
    end)

    --更新模型
    self.uiLogic:on_refresh('HUD.Console.Data.left.model', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            ui:set_ui_model_unit(unit)
        end
    end)

    --更新攻击力
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.英雄.攻击.攻击力.攻击值', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            local minAtk = unit:get_attr("物理攻击")
            local maxAtk = FW.unitMgr:calMaxAttack_phy(unit)
            if maxAtk == minAtk then
                ui:set_text(tostring(minAtk))
            else
                ui:set_text(string.format('%d ~ %d', minAtk, maxAtk))
            end
        end
    end)

    --更新技能栏
    self.uiLogic:on_refresh('HUD.Console.Data.right.技能栏', function(ui, local_player)
        if not local_player:get_selecting_unit() then
            return
        end

        for i, parent in ipairs(ui:get_childs()) do
            local slot = parent:get_child('skill_btn')
            if slot then
                local ability = local_player:get_selecting_unit():get_ability_by_slot('英雄', i)
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
        end
    end)

    --更新升级栏
    self.uiLogic:on_refresh('HUD.Console.Data.right.升级栏', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end
        local abilityPoint = u:get_ability_point()
        for i, parent in ipairs(ui:get_childs()) do
            local slot = parent:get_child('button_' .. i)
            if slot then
                local ability = u:get_ability_by_slot('英雄', i)
                if ability and ability:get_int_attr('当前等级') < ability:get_int_attr('最大等级') then
                    slot:set_visible(true)
                    slot:set_image(ability:get_icon())
                    slot:get_child('levelup_1.label_3'):set_text(tostring(ability:get_int_attr('当前等级')))
                    if abilityPoint > 0 then
                        slot:set_button_enable(true)
                        slot:set_alpha(100)
                    else
                        slot:set_button_enable(false)
                        slot:set_alpha(40)
                    end
                else
                    slot:set_visible(false)
                end
            end
        end
    end)

    --更新技能点
    self.uiLogic:on_refresh('HUD.Console.Data.right.技能栏.layout_12.levelup.levelup_1', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end
        local abilityPoint = u:get_ability_point()
        local pointText = ui:get_child('label_3')
        if abilityPoint > 0 then
            ui:set_visible(true)
            if pointText then
                pointText:set_text(tostring(abilityPoint))
            end
        else
            ui:set_visible(false)
        end
    end)
    --更新道具栏
    self.uiLogic:on_refresh('HUD.Console.Data.middle.物品栏', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end

        for i, slot in ipairs(ui:get_childs()) do
            slot:get_child('equip_slot_' .. i):set_ui_unit_slot(u, y3.const.SlotType.BAR, i - 1)
        end
    end)
    --更新buff列表
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.英雄.状态.bufflist', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end

        for i, slot in ipairs(ui:get_childs()) do
            slot:get_child('buff_item_' .. i):set_buff_on_ui(u)
        end
    end)

    y3.game:event('选中-单位', function(trg, data)
        self.uiLogic:refresh('*', data.player)
    end)

    y3.game:event('选中-单位组', function(trg, data)
        self.uiLogic:refresh('*', data.player)
    end)

    -- y3.game:event('单位-获得经验后', function(trg, data)
    --     y3.player.with_local(function(local_player)
    --         if local_player:get_selecting_unit() == data.unit then
    --             self.uiLogic:refresh('经验条')
    --         end
    --     end)
    -- end)

    -- y3.game:event('单位-升级', function(trg, data)
    --     y3.player.with_local(function(local_player)
    --         if local_player:get_selecting_unit() == data.unit then
    --             self.uiLogic:refresh('经验条')
    --         end
    --     end)
    -- end)

    -- y3.game:event('键盘-按下', y3.const.KeyboardKey['SPACE'], function(trg, data)
    --     local u = data.player:get_selecting_unit()
    --     if not u then
    --         return
    --     end

    --     y3.camera.set_camera_follow_unit(data.player, u, 0, 0, 0)
    -- end)

    -- y3.game:event('键盘-抬起', y3.const.KeyboardKey['SPACE'], function(trg, data)
    --     y3.camera.cancel_camera_follow_unit(data.player)
    -- end)

    y3.game:event('单位-获得经验后', function(trg, data)
        y3.player.with_local(function(local_player)
            if local_player:get_selecting_unit() == data.unit then
                self.uiLogic:refresh('HUD.Console.Data.middle.状态栏.英雄.等级经验条')
            end
        end)
    end)

    y3.game:event('单位-升级', function(trg, data)
        y3.player.with_local(function(local_player)
            if local_player:get_selecting_unit() == data.unit then
                self.uiLogic:refresh('HUD.Console.Data.middle.状态栏.英雄.等级经验条')
                self.uiLogic:refresh('HUD.Console.Data.right.技能栏.layout_12.levelup.levelup_1')
            end
        end)
    end)
    y3.game:event('技能-学习', function(trg, data)
        self.uiLogic:refresh('HUD.Console.Data.right.升级栏')
    end)

    y3.game:event('物品-获得', function(trg, data)
        self.uiLogic:refresh('HUD.Console.Data.middle.物品栏', data.unit:get_owner_player())
    end)
    y3.game:event('效果-获得', function(trg, data)
        self.uiLogic:refresh('HUD.Console.Data.middle.状态栏.英雄.状态.bufflist', data.owner_unit:get_owner_player())
    end)

    y3.timer.loop(0.1, function(timer, count)
        self.uiLogic:refresh('HUD.Console.Data.left.血量')
        self.uiLogic:refresh('HUD.Console.Data.left.蓝量')
        self.uiLogic:refresh('HUD.Console.Data.middle.状态栏.英雄.攻击.攻击力.攻击值')
    end, '刷新UI', true)



    self.uiLogic:on_event('HUD.Console.Data.right.技能栏.layout_12.levelup', '左键-按下', function(ui, local_player)
        local abilityHub = ui:get_parent():get_parent()
        local upgradeHub = ui:get_parent():get_parent():get_parent():get_child('升级栏')
        if abilityHub then
            abilityHub:set_visible(false)
        end
        if upgradeHub then
            upgradeHub:set_visible(true)
            self.uiLogic:refresh('HUD.Console.Data.right.升级栏')
        end
    end)
    self.uiLogic:on_event('HUD.Console.Data.right.升级栏.layout_12.icon', '左键-按下', function(ui, local_player)
        local upgradeHub = ui:get_parent():get_parent()
        local abilityHub = ui:get_parent():get_parent():get_parent():get_child('技能栏')
        if abilityHub then
            abilityHub:set_visible(true)
            self.uiLogic:refresh('HUD.Console.Data.right.技能栏')
        end
        if upgradeHub then
            upgradeHub:set_visible(false)
        end
    end)

    for i = 1, 11, 1 do
        self.uiLogic:on_event('HUD.Console.Data.right.升级栏.layout_'..i..'.button_'..i, '左键-按下', function(ui, local_player)
            local u = local_player:get_selecting_unit()
            if not u then
                return
            end
            local ability = u:get_ability_by_slot('英雄', i)
            if ability then
                ability:learn()
            end
        end)
    end
end

return hudPanel
