local maingame = {}


function maingame:enter()
    print("进入 MAINGAME")
    UIManager:show_ui("MAINGAME")

    -- 创建主角
    for i = 1, GameManager.default_player_cnt do
        local player = y3.player.get_by_id(i)
        if player:get_state() == 1 then
            local hero = y3.unit.create_unit(player, GameManager.players[i].hero_id, y3.point.create(0, 0, 0), 180.0)

            y3.player.with_local(function(local_player)
                if local_player:get_id() == player:get_id() then
                    hero:event('单位-击杀', function(trg, data)
                        -- player:display_info("player" .. i .. "击杀目标 " .. data.unit:get_name())
                        y3.sync.send("sync_data", { msg = "kill_unit", cnt = 1 })
                    end)
                end
            end)
        end
    end



    -- hero:event('单位-死亡', function(trg, data)
    --     self:show_result("lose")
    -- end)

    -- 创建刷怪点
    local building = y3.unit.create_unit(y3.player(31), 134237546, y3.point.create(-1000, -1000, 0), 0.0)
end

function maingame:update()
    -- if GameManager.player_kill >= 10 then
    --     self:show_result("win")
    -- end
end

function maingame:exit()

end

function maingame:show_result(result)
    GameManager.game_result = result
    StateManager:set_state("RESULT")
end

return maingame
