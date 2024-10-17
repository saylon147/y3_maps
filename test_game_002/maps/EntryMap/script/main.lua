-- 游戏启动后会自动运行此文件

--在开发模式下，将日志打印到游戏中
if y3.game.is_debug_mode() then
    y3.config.log.toGame = true
    y3.config.log.level  = 'debug'
else
    y3.config.log.toGame = false
    y3.config.log.level  = 'info'
end


require("src.game_manager")
require("src.state_manager")
require("src.ui_manager")
require("src.unit_manager")


y3.game:event('游戏-初始化', function(trg, data)
    -- print('游戏-初始化')
    GameManager:init()
    StateManager:set_state("PREPARE")
end)


-- 主循环
y3.timer.loop(1 / 30, function()
    StateManager:update()
    UIManager:update()
end)
