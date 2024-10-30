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
    --刷新金币
    self.uiLogic:on_refresh('HUD.Top.金币.image_3.label_2', function(ui, local_player)
        ui:set_text(tostring(local_player:get_attr('gold')))
    end)

    --刷新木材
    self.uiLogic:on_refresh('HUD.Top.木材.image_3.label_2', function(ui, local_player)
        ui:set_text(tostring(local_player:get_attr('wood')))
    end)

    --更新名称
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.英雄.等级经验条.单位名', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            ui:set_text(unit:get_name())
        end
    end)
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.生物.单位名', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            ui:set_text(unit:get_name())
        end
    end)
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.建筑.单位名', function(ui, local_player)
        local unit = local_player:get_selecting_unit()
        if unit then
            ui:set_text(unit:get_name())
        end
    end)
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.商店.单位名', function(ui, local_player)
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
        local unit = local_player:get_selecting_unit()
        if not unit then
            return
        end
        if unit:has_tag('followHero') or unit:has_tag('summoner') then
            for i, parent in ipairs(ui:get_childs()) do
                local slot = parent:get_child('skill_btn')
                if slot then
                    local ability = unit:get_ability_by_slot('英雄', i)
                    if ability then
                        slot:set_visible(true)
                        --必须要主动绑定，否则会闪烁一下
                        slot:bind_ability(ability)
                        if unit:get_owner() ~= local_player then
                            slot:set_visible(false)
                        end
                    else
                        slot:set_visible(false)
                    end
                    slot:set_button_enable(true)
                end
            end
        elseif unit:has_tag('enemy') or unit:has_tag('minio') then
            for i, parent in ipairs(ui:get_childs()) do
                local slot = parent:get_child('skill_btn')
                if slot then
                    local ability = unit:get_ability_by_slot('命令', i)
                    if ability then
                        slot:set_visible(true)
                        --必须要主动绑定，否则会闪烁一下
                        slot:bind_ability(ability)
                    else
                        slot:set_visible(false)
                    end
                    slot:set_button_enable(false)
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
    self.uiLogic:on_refresh('HUD.Console.Data.right.技能栏.layout_12.levelup', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end
        local abilityPoint = u:get_ability_point()
        local pointText = ui:get_child('levelup_1.label_3')
        if abilityPoint > 0 and (u:has_tag('followHero') or u:has_tag('summoner')) then
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
    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏.生物.状态.bufflist', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end

        for i, slot in ipairs(ui:get_childs()) do
            slot:get_child('buff_item_' .. i):set_buff_on_ui(u)
        end
    end)

    self.uiLogic:on_refresh('HUD.Console.Data.middle.状态栏', function(ui, local_player)
        for index, child in ipairs(ui:get_childs()) do
            child:set_visible(false)
        end
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end

        if u:has_tag("followHero") or u:has_tag("summoner") then
            ui:get_child('英雄'):set_visible(true)
        elseif u:has_tag("enemy") or u:has_tag("minio") then
            ui:get_child('生物'):set_visible(true)
            ui:get_child('生物.生命周期'):set_visible(false)
        elseif u:has_tag("building") then
            ui:get_child('建筑'):set_visible(true)
            ui:get_child('建筑.建造中'):set_visible(false)
        elseif u:has_tag("shop") then
            ui:get_child('商店'):set_visible(true)
        end
    end)

    self.uiLogic:on_refresh('HUD.Console.Data.right', function(ui, local_player)
        for index, child in ipairs(ui:get_childs()) do
            child:set_visible(false)
        end
        local u = local_player:get_selecting_unit()
        if not u then
            return
        end
        if u:has_tag("followHero") or u:has_tag("summoner") then
            ui:get_child("技能栏"):set_visible(true)
        elseif u:has_tag("enemy") or u:has_tag("minio") then
            ui:get_child("技能栏"):set_visible(true)
        elseif u:has_tag("shop") then
            ui:get_child("商店"):set_visible(true)
        end
    end)

    self.uiLogic:on_refresh('HUD', function(ui, local_player)
        local u = local_player:get_selecting_unit()
        if not u then
            ui:get_child('Console.Data'):set_visible(false)
            ui:get_child('Console.frame.cover'):set_visible(true)
        else
            ui:get_child('Console.Data'):set_visible(true)
            if u:has_tag("summoner") then
                ui:get_child('Console.frame.cover'):set_visible(false)
            else
                ui:get_child('Console.frame.cover'):set_visible(true)
            end
        end
    end)

    y3.game:event('选中-单位', function(trg, data)
        self.uiLogic:refresh('*', data.player)
        if data.unit:has_tag("followHero") or data.unit:has_tag("summoner") then
            self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.英雄.护甲.攻击力.护甲值', '文本', '物理防御')
            self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.英雄.力量.力量值', '文本', '力量')
            self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.英雄.敏捷.敏捷值', '文本', '敏捷')
            self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.英雄.智力.智力值', '文本', '智力')
        elseif data.unit:has_tag("enemy") or data.unit:has_tag("minio") then
            self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.生物.护甲.攻击力.护甲值', '文本', '物理防御')
        elseif data.unit:has_tag('building') then
            self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.建筑.建造完成.护甲.攻击力.护甲值', '文本', '物理防御')
        elseif data.unit:has_tag('shop') then
            self.uiLogic:bind_unit_attr('HUD.Console.Data.middle.状态栏.商店.护甲.攻击力.护甲值', '文本', '物理防御')
        end
    end)

    y3.game:event('选中-单位组', function(trg, data)
        self.uiLogic:refresh('*', data.player)
    end)

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
                self.uiLogic:refresh('HUD.Console.Data.right.技能栏.layout_12.levelup')
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
        self.uiLogic:refresh('HUD.Top.金币.image_3.label_2')
        self.uiLogic:refresh('HUD.Top.木材.image_3.label_2')
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
        self.uiLogic:on_event('HUD.Console.Data.right.升级栏.layout_' .. i .. '.button_' .. i, '左键-按下',
            function(ui, local_player)
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
    self:initShopLogic()
    self.uiLogic:refresh('*')
end

function hudPanel:initShopLogic()
    for i = 1, 12, 1 do
        self.uiLogic:on_refresh('HUD.Console.Data.right.商店.layout_' .. i .. '.button_' .. i, function(ui, local_player)
            local unit = local_player:get_selecting_unit()
            if not unit or not unit:has_tag('shop') then
                return
            end

            local item = FW.shopMgr:getShopItemsByShopKeyAndIndex(unit:get_name(), i)
            if item then
                local id = item.itemTemplate.id
                local playerBuyCount = 0
                local itemName = y3.item.get_name_by_key(id)
                if local_player:kv_has(unit:get_name() .. '_' .. itemName) then
                    playerBuyCount = local_player:kv_load(unit:get_name() .. '_' .. itemName, 'integer')
                end
                local count = y3.object.item[id].data.max_stock - playerBuyCount
                ui:set_visible(true)
                ui:set_image(y3.item.get_icon_id_by_key(id))
                ui:get_child('levelup_1.label_3'):set_text(tostring(count))
                if count > 0 then
                    ui:set_button_enable(true)
                else
                    ui:set_button_enable(false)
                end
            else
                ui:set_visible(false)
            end
        end)
        self.uiLogic:on_event('HUD.Console.Data.right.商店.layout_' .. i .. '.button_' .. i, '鼠标-移入',
            function(ui, local_player)
                local unit = local_player:get_selecting_unit()
                if not unit or not unit:has_tag('shop') then
                    return
                end
                local shopDescUI = ui:get_parent():get_parent():get_child('商品说明')
                if shopDescUI then
                    shopDescUI:set_visible(true)
                    local item = FW.shopMgr:getShopItemsByShopKeyAndIndex(unit:get_name(), i)
                    if item then
                        local id = item.itemTemplate.id
                        shopDescUI:get_child('name'):set_text(y3.item.get_name_by_key(id))
                        if item.priceType == 'wood' then
                            shopDescUI:get_child('price.icon1'):set_image(134227826)
                        else
                            shopDescUI:get_child('price.icon1'):set_image(134253341)
                        end

                        shopDescUI:get_child('price'):set_text(tostring(y3.item.get_item_buy_price_by_key(id,
                            item.priceType)))
                        shopDescUI:get_child('desc1'):set_visible(false)
                        shopDescUI:get_child('desc2'):set_text(y3.item.get_description_by_key(id))
                    end
                end
            end)
        self.uiLogic:on_event('HUD.Console.Data.right.商店.layout_' .. i .. '.button_' .. i, '鼠标-移出',
            function(ui, local_player)
                ui:get_parent():get_parent():get_child('商品说明'):set_visible(false)
            end)
        self.uiLogic:on_event('HUD.Console.Data.right.商店.layout_' .. i .. '.button_' .. i, '左键-按下',
            function(ui, local_player)
                local unit = local_player:get_selecting_unit()
                if not unit or not unit:has_tag('shop') then
                    return
                end
                local item = FW.shopMgr:getShopItemsByShopKeyAndIndex(unit:get_name(), i)
                local itemId = item.itemTemplate.id
                y3.sync.send('购买商店物品', {
                    itemId = itemId,
                    shop = unit:get_name(),
                    player_id = local_player:get_id()
                })
            end)
    end
end

return hudPanel
