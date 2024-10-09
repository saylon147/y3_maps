-- 游戏启动后会自动运行此文件
GameMgr = require 'scripts.GameMgr'
--require "y3.演示.demo.合成"
--在开发模式下，将日志打印到游戏中
if y3.game.is_debug_mode() then
    y3.config.log.toGame = true
    y3.config.log.level  = 'debug'
else
    y3.config.log.toGame = false
    y3.config.log.level  = 'info'
end


y3.game:event('游戏-初始化', function(trg, data)
    print('Hello, Y3!')
    GameMgr:gameInit()
end)

y3.timer.loop(10, function(timer, count)
    print('每5秒显示一次文本，这是第' .. tostring(count) .. '次')
    if (GlobalVar["playerCount"] > 0) then
        for i = 1, 2, 1 do
            --if GlobalVar["vote"][i] ~= nil then
                --print('玩家' .. i .. '打印:' .. i .. ':' .. GlobalVar["vote"][i])
                y3.player.get_by_id(i):create_unit(134274912)
            --end
        end
    end
end)

y3.game:event('键盘-按下', y3.const.KeyboardKey['SPACE'], function()
    print('你按下了空格键！')
end)

y3.sync.onSync("vote",function (data,source)
    GlobalVar["vote"][source:get_id()] = data
    y3.player.with_local(function(localPlayer) 
        localPlayer:display_message("玩家"..source:get_id().."投了"..GlobalVar["vote"][source:get_id()])
    end)
end)