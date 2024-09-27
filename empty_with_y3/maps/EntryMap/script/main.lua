-- 游戏启动后会自动运行此文件

--在开发模式下，将日志打印到游戏中
if y3.game.is_debug_mode() then
    y3.config.log.toGame = true
    y3.config.log.level  = 'debug'
else
    y3.config.log.toGame = false
    y3.config.log.level  = 'info'
end

-- y3.game:event('游戏-初始化', function (trg, data)
--     print('Hello, Y3!')
-- end)

-- y3.timer.loop(5, function (timer, count)
--     print('每5秒显示一次文本，这是第' .. tostring(count) .. '次')
-- end)

-- y3.game:event('键盘-按下', y3.const.KeyboardKey['SPACE'], function ()
--     print('你按下了空格键！')
-- end)


local battle_wave = require 'y3.演示.demo.防守图.刷兵'
local game_result = require 'y3.演示.demo.防守图.游戏结果'

y3.ltimer.wait(0.5, function()
    -- 为玩家1创建主控英雄并选中
    local hero = y3.player(1):create_unit(134274912, y3.point.create(0, 0, 0), 180.0)
    y3.player(1):select_unit(hero)

    -- 让英雄强一点
    hero:set_level(10)
    hero:add_attr('物理攻击', 70)
    hero:add_attr('法术攻击', 150)
    hero:add_attr('攻击速度', 200)
    hero:add_attr('物理吸血', 20)
    hero:add_attr('暴击率', 20)
    hero:add_attr('技能吸血', 200)
    hero:add_attr('魔法恢复', 10)
    hero:add_attr('冷却缩减', 50)

    -- 玩家英雄死亡，游戏失败
    hero:event('单位-死亡', function()
        game_result.lose()
        battle_wave.stop()
    end)
end)

-- 等待2秒后开始刷兵
y3.ltimer.wait(2, function()
    battle_wave.next_wave()
    -- 第一次出兵后，每15秒再出一次兵
    y3.ltimer.loop(15, function()
        battle_wave.next_wave()
    end)
end)

y3.ltimer.loop(1, function(timer)
    -- 如果场上的怪超过30个，判定游戏失败
    if battle_wave.get_alive_count() >= 30 then
        game_result.lose()
        battle_wave.stop()
        timer:remove()
    end
    -- 如果场上没有怪了，也没有下一波怪了，判定游戏胜利
    if battle_wave.get_alive_count() == 0 and not battle_wave.has_next() then
        game_result.win()
        battle_wave.stop()
        timer:remove()
    end
end)
