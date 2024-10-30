---@class shopMgr
local shopMgr = Class 'shopMgr'

---@enum(key) FW.shopMgr.shopType
shopMgr.itemTemplate = {
    ['木材'] = require 'scripts.item.item_wood'
}

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
function itemMgr:getItemPriceByName(name,moneyType)
    local price = y3.item.get_item_buy_price_by_key(self.itemTemplate[name].id, moneyType)
    return price
end

---注册合成配方
---@param result any # 合成目标 "target"
---@param ingredients any[] # 合成素材 {"material1", "material2", "material3"}
function itemMgr.register(result, ingredients)
    maker:register(result, ingredients)
end

return itemMgr
