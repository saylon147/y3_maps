-- 游戏启动后会自动运行此文件

--在开发模式下，将日志打印到游戏中
if y3.game.is_debug_mode() then
    y3.config.log.toGame = true
    y3.config.log.level  = 'debug'
else
    y3.config.log.toGame = false
    y3.config.log.level  = 'info'
end


require("game_manager")
require("state_manager")
StateManager:register_state("prepare", require("states.prepare"))
StateManager:register_state("maingame", require("states.maingame"))
StateManager:register_state("result", require("states.result"))


y3.game:event('游戏-初始化', function(trg, data)
    print('游戏-初始化 事件触发')
    StateManager:set_state("prepare")
end)


-- y3.game:event('键盘-按下', y3.const.KeyboardKey['SPACE'], function()
--     print('你按下了空格键！')
-- end)


-- 主循环
y3.timer.loop(1 / 30, function()
    StateManager:update()
end)
