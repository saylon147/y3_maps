---@class ECAHelper
---@field call fun(name: '界面初始化', v1: Player)
---@field call fun(name: '单选英雄_选中英雄', v1: Unit, v2: Player)
---@field call fun(name: '更新玩家选中状态', v1: Player)
---@field call fun(name: '多选单位_选中单位', v1: UnitGroup, v2: Player)
---@field call fun(name: '多选单位_选择分组', v1: Player, v2: integer)
---@field call fun(name: '单选生物_选中生物_普通', v1: Unit, v2: Player)
---@field call fun(name: '单选生物_选中生物_召唤物', v1: Unit, v2: Player)
---@field call fun(name: '单选单位_选中商店', v1: Unit, v2: Player)
---@field call fun(name: '单选单位_选中建筑', v1: Unit, v2: Player)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('界面初始化', function (_, v1)
    y3.game.send_custom_event(1202296270, {
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v1)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('单选英雄_选中英雄', function (_, v1, v2)
    y3.game.send_custom_event(1695746711, {
        ['英雄'] = y3.py_converter.lua_to_py_by_lua_type('Unit', v1),
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v2)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('更新玩家选中状态', function (_, v1)
    y3.game.send_custom_event(1460986851, {
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v1)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('多选单位_选中单位', function (_, v1, v2)
    y3.game.send_custom_event(1902559067, {
        ['选中单位组'] = y3.py_converter.lua_to_py_by_lua_type('UnitGroup', v1),
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v2)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('多选单位_选择分组', function (_, v1, v2)
    y3.game.send_custom_event(2053950930, {
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v1),
        ['组号'] = v2
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('单选生物_选中生物_普通', function (_, v1, v2)
    y3.game.send_custom_event(1708434595, {
        ['生物'] = y3.py_converter.lua_to_py_by_lua_type('Unit', v1),
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v2)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('单选生物_选中生物_召唤物', function (_, v1, v2)
    y3.game.send_custom_event(2000364876, {
        ['生物'] = y3.py_converter.lua_to_py_by_lua_type('Unit', v1),
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v2)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('单选单位_选中商店', function (_, v1, v2)
    y3.game.send_custom_event(1512146893, {
        ['商店'] = y3.py_converter.lua_to_py_by_lua_type('Unit', v1),
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v2)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('单选单位_选中建筑', function (_, v1, v2)
    y3.game.send_custom_event(1245810636, {
        ['建筑'] = y3.py_converter.lua_to_py_by_lua_type('Unit', v1),
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v2)
    })
end)
