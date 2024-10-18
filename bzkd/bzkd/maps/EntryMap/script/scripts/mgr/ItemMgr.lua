local M = {}
M.itemTemplate = {
    -- item_exp = require 'scripts.item.item_exp',
    -- item_gold = require 'scripts.item.item_gold',
    -- item_heath = require 'scripts.item.item_heath'
}
M.items = {

}
local function add_itemGroup(owner, point, item)
    local id = FW.playerMgr:getPlayerIdByPoint(owner, point)
    if M.items[id] == nil then
        M.items[id] = {}
    end
    table.insert(M.items[id], item)
end

---@param owner Player|Unit
---@param type string
---@param point Point 点
---@return Item item
function M:createItem(owner, type, point)
    local template = self.itemTemplate[type]
    local item = template:create(owner, point)
    item:kv_save('template', template)
    add_itemGroup(owner, point, item)
    return item
end

function M:roundGet()
    for key, itemGroup in pairs(M.items) do
        for index, item in ipairs(itemGroup) do
            local owner = y3.player.get_by_id(key)
            local hero = FW.playerMgr:getHeroByPlayer(owner)
            item:set_point(hero:get_point())
        end
    end
end

return M
