local M = {}
M.id = 134256863
M.template = y3.object.unit[M.id] --物编信息
---@param owner Player|Unit
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M
