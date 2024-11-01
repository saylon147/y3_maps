---@class shopMgr
local shopMgr = Class 'shopMgr'

---@enum(key) FW.shopMgr.shopType
---autocode---
shopMgr.shopTemplate = {
	['雇佣兵营地'] = require 'scripts.shop.shop_gybyd',
}
---autocode---

---@param key FW.shopMgr.shopType
---@return table shop
function shopMgr:getShopTemplateByKey(key)
    return self.shopTemplate[key]
end

---@param key FW.shopMgr.shopType
---@param index integer
---@return any item
function shopMgr:getShopItemsByShopKeyAndIndex(key, index)
    local shop = self:getShopTemplateByKey(key)
    if shop.items[index] then
        return shop.items[index]
    end
    return nil
end

-- 进行帧同步
y3.sync.onSync('购买商店物品', function(data, source)
    if not data then
        return
    end
    local item_name = data.itemName
    local itemTemplate = FW.itemMgr.itemTemplate[item_name]
    local id = itemTemplate.id
    local player = y3.player(data.player_id)
    local u = FW.playerMgr:getSummonerByPlayer(player)
    local shopName = data.shop
    local maxCount = data.itemCount
    local cd = data.itemCd
    if not u then
        print('没有召唤师单位')
        return
    end
    local items = u:get_all_items():pick()
    if #items >= 6 and itemTemplate.item_type == 'ability' then
        print('没有更多的格子买物品')
        return
    end

    -- 判断是否有足够资源来购买
    local gold = player:get_attr('gold')
    local wood = player:get_attr('wood')
    local price = itemTemplate.price
    local kvCountStr = string.format('%s_%s_count', shopName, item_name)
    local kvTimeStr = string.format('%s_%s_time', shopName, item_name)

    -- 获取当前玩家物品栏中所有物品名
    -- local player_item_names = {}
    -- for i, v in ipairs(items) do
    --     table.insert(player_item_names, v:get_name())
    -- end

    local playerBuyCount = 0
    local now_time_stamp = y3.game.get_current_server_time().timestamp

    if maxCount ~= -1 then
        if player:kv_has(kvCountStr) then
            playerBuyCount = player:kv_load(kvCountStr, 'integer')
            
        end
        if playerBuyCount + 1 > maxCount then
            price('商品卖完了')
            FW.uiMgr:getUITemplate("hudPanel").uiLogic:refresh('HUD.Console.Data.right.商店')
            return
        end
    end

    if playerBuyCount + 1 == maxCount and cd ~= -1 then
        player:kv_save(kvTimeStr, now_time_stamp)
    end
    
    -- 计算当前物品花费
    if itemTemplate.price_type == 'gold' and gold >= price then
        player:set('gold', gold - price)
    elseif itemTemplate.price_type == 'wood' and wood >= price then
        player:set('wood', wood - price)
    else
        print('玩家资源不足')
        FW.uiMgr:getUITemplate("hudPanel").uiLogic:refresh('HUD.Console.Data.right.商店')
        return;
    end


    playerBuyCount = playerBuyCount + 1
    player:kv_save(kvCountStr, playerBuyCount)
    FW.uiMgr:getUITemplate("hudPanel").uiLogic:refresh('HUD.Console.Data.right.商店')
    u:add_item(id)

    -- 只有在配方中的物品才需计算当前所需花费
    -- local res = nil
    -- local maker = FW.itemMgr.get_maker()
    -- if maker:get_recipes()[item_name] then
    --     res = maker:target_check(item_name, player_item_names)
    --     if res then
    --         for _, v in ipairs(res.lost) do
    --             goldPrice = goldPrice - FW.itemMgr:getItemPriceByName(v, 'gold')
    --             woodPrice = woodPrice - FW.itemMgr:getItemPriceByName(v, 'wood')
    --         end
    --     end
    -- end

    -- if gold >= goldPrice and wood >= woodPrice then
    --     -- 如果购买的物品存在配方则需移除其合成素材
    --     if res then
    --         for _, v in ipairs(res.lost) do
    --             local cur_item_key = FW.itemMgr:getItemIdByName(v)
    --             if cur_item_key then
    --                 u:remove_item(cur_item_key, 1)
    --             end
    --         end
    --     end
    --     -- 扣除玩家gold并给玩家添加该物品
    --     player:set('gold', gold - goldPrice)
    --     player:set('wood', wood - woodPrice)
    --     local item_key = id
    --     if item_key then
    --         u:add_item(item_key)
    --     end

    --     local playerBuyCount = 0
    --     if player:kv_has(shopName .. '_' .. item_name) then
    --         playerBuyCount = player:kv_load(shopName .. '_' .. item_name, 'integer')
    --     end
    --     playerBuyCount = playerBuyCount + 1
    --     player:kv_save(shopName .. '_' .. item_name, playerBuyCount)
    --     FW.uiMgr:getUITemplate("hudPanel").uiLogic:refresh('HUD.Console.Data.right')
    -- else
    --     print('玩家资源不足')
    -- end
end)


return shopMgr
