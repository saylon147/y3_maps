---@class itemMgr
local itemMgr = Class 'itemMgr'
require 'y3.tools.synthesis'
local maker = New 'Synthesis' ()

---@param owner Player
---@param type string
---@param point Point 点
---@return Item item
function itemMgr:createItem(owner, type, point)
    local template = self.itemTemplate[type]
    local item = template:create(owner, point)
    item:kv_save('template', template)
    return item
end

---输入物品名返回其购买价格
---@param name FW.itemMgr.itemType # 物品名
---@param moneyType string 货币类型
---@return number? # 对应的价格
function itemMgr:getItemPriceByName(name, moneyType)
    local price = y3.item.get_item_buy_price_by_key(self.itemTemplate[name].id, moneyType)
    return price
end

---输入物品名返回其key
---@param name FW.itemMgr.itemType # 物品名
---@return py.ItemKey? key# 物品id
function itemMgr:getItemIdByName(name)
    return self.itemTemplate[name].id
end

---注册合成配方
---@param result any # 合成目标 "target"
---@param ingredients any[] # 合成素材 {"material1", "material2", "material3"}
function itemMgr.register(result, ingredients)
    maker:register(result, ingredients)
end

---返回maker对象
---@return Synthesis # 合成处理对象
function itemMgr.get_maker()
    return maker
end

---@enum(key) FW.itemMgr.itemType
---autocode---
itemMgr.itemTemplate = {
	['释放范围爆炸'] = require 'scripts.item.ability.item_zd',
	['敏捷书'] = require 'scripts.item.attr.item_mjs',
	['食尸鬼'] = require 'scripts.item.enemy.item_ssg',
	['剑圣'] = require 'scripts.item.followHero.item_js',
	['增加金币收益'] = require 'scripts.item.kv.item_jbsy',
	['随机添加属性'] = require 'scripts.item.randomAttr.item_rattr',
}
---autocode---


-- 合成相关用不到
-- itemMgr.register('经验', { '木材', '木材', '金币' })

-- y3.game:event('物品-获得', function(trg, data)
--     if not data.unit:has_tag('summoner') then
--         return
--     end
--     -- 存储当前单位全部的物品名
--     local item_names = {}
--     for i, v in ipairs(data.unit:get_all_items():pick()) do
--         table.insert(item_names, v:get_name())
--     end

--     -- 获取合成结果
--     local res = maker:check(item_names)

--     -- 如果可以合成
--     if res then
--         -- 将合成目标所需的素材从该单位身上移除
--         for _, v in ipairs(res.lost) do
--             local item_key = FW.itemMgr:getItemIdByName(v)
--             if item_key then
--                 data.unit:remove_item(item_key, 1)
--             end
--         end

--         -- 给该单位增添合成后的目标物品
--         local item_key = FW.itemMgr:getItemIdByName(res.get)
--         if item_key then
--             data.unit:add_item(item_key)
--         end
--     end
-- end)


return itemMgr
