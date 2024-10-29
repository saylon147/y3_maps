y3.eca.def '获取单位攻击浮动值'
-- 声明第一个参数的ECA类型
: with_param('单位', 'Unit')
-- 声明返回值的ECA类型
: with_return('伤害', 'number')
---@param unit Unit
---@return number
: call(function (unit)
    return FW.unitMgr:getRandomAtk(unit)
end)