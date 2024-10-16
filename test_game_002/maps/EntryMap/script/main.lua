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
require("ui_manager")
StateManager:register_state("prepare", require("states.prepare"))
StateManager:register_state("maingame", require("states.maingame"))
StateManager:register_state("result", require("states.result"))


y3.game:event('游戏-初始化', function(trg, data)
    print('游戏-初始化')
    for i = 1, 4 do
        if y3.player.get_by_id(i):get_state() ~= 1 then -- 其他位置的state是2
            GameManager.player_ready[i] = true
        end
    end
    StateManager:set_state("prepare")
end)


-- y3.game:event('键盘-按下', y3.const.KeyboardKey['SPACE'], function()
--     print('你按下了空格键！')
-- end)


-- 主循环
y3.timer.loop(1 / 30, function()
    StateManager:update()
    UIManager:update()
end)


y3.sync.onSync("player_ready", function(data, source)
    -- print(data, type(data))
    -- print(source, type(source))
    y3.player.with_local(function(local_player)
        local_player:display_info("Player" .. source:get_id() .. " is Ready")
    end)
    GameManager.player_ready[source:get_id()] = true
end)
