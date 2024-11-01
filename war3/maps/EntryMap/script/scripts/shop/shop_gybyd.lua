--雇佣兵营地
local M = {}
M.id = 134257687
M.lua_name = 'gybyd'
M.name = '雇佣兵营地'
M.desc = '描述'
M.template = y3.object.item[M.id] --物编信息
---count -1代表无限买
---cd -1代表不刷新
M.items = {
	{
        itemTemplate = FW.itemMgr.itemTemplate['剑圣'],
        count = 1,
        cd = -1,
    },
	{
        itemTemplate = FW.itemMgr.itemTemplate['食尸鬼'],
        count = 1,
        cd = 30,
    },
	{
        itemTemplate = FW.itemMgr.itemTemplate['敏捷书'],
        count = -1,
        cd = 1,
    },
}

---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    local unit = y3.unit.create_unit(owner, self.id, point, direction)
    return unit
end
return M