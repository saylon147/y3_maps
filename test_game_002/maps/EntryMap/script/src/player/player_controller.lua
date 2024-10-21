---
PlayerController = {

}


function PlayerController:init(player)
    player:kv_save('x', 0)
    player:kv_save('y', 0)
    player:set_mouse_click_selection(false)
    player:set_mouse_drag_selection(false)

    -- 给本方的hero添加按键操作控制
    player:event('键盘-按下', y3.const.KeyboardKey['W'], function(trg, data)
        data.player:kv_save('y', 1)
    end)
    player:event('键盘-抬起', y3.const.KeyboardKey['W'], function(trg, data)
        data.player:kv_save('y', 0)
    end)
    player:event('键盘-按下', y3.const.KeyboardKey['A'], function(trg, data)
        data.player:kv_save('x', -1)
    end)
    player:event('键盘-抬起', y3.const.KeyboardKey['A'], function(trg, data)
        data.player:kv_save('x', 0)
    end)
    player:event('键盘-按下', y3.const.KeyboardKey['S'], function(trg, data)
        data.player:kv_save('y', -1)
    end)
    player:event('键盘-抬起', y3.const.KeyboardKey['S'], function(trg, data)
        data.player:kv_save('y', 0)
    end)
    player:event('键盘-按下', y3.const.KeyboardKey['D'], function(trg, data)
        data.player:kv_save('x', 1)
    end)
    player:event('键盘-抬起', y3.const.KeyboardKey['D'], function(trg, data)
        data.player:kv_save('x', 0)
    end)
end

local function handle_player_move(player)
    local x = player:kv_load('x', 'integer')
    local y = player:kv_load('y', 'integer')
    local degree = 0
    local distance = 0
    local hero = GameManager.players[player:get_id()].heroes[1]
    local aim_point
    if x == 0 and y == 0 then
        if hero:is_moving() then
            hero:stop()
        end
        return
    elseif x == 1 and y == -1 then
        degree = 45
    elseif x == 1 and y == 0 then
        degree = 90
    elseif x == 1 and y == 1 then
        degree = 135
    elseif x == 0 and y == 1 then
        degree = 180
    elseif x == -1 and y == 1 then
        degree = 225
    elseif x == -1 and y == 0 then
        degree = 270
    elseif x == -1 and y == -1 then
        degree = 315
    elseif x == 0 and y == -1 then
        degree = 0
    end
    while distance < 1000 do
        distance = distance + 50
        local aim_point = hero:get_point():get_point_offset_vector(degree, distance)
        if not hero:can_blink_to(aim_point) then
            distance = distance - 50
            break
        end
    end
    local target_point = hero:get_point():get_point_offset_vector(degree, distance)
    hero:move_to_pos(target_point)
end

function PlayerController:update()
    for i = 1, GameManager.default_player_cnt do
        if GameManager.players[i].exist then
            handle_player_move(y3.player.get_by_id(i))
        end
    end
end

return PlayerController
