local M = {}
M.id = 134218565
M.template = y3.object.item[M.id] --物编信息
---@param owner Player
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M
