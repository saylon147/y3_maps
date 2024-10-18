local result = {}

function result:enter()
    -- print("进入 RESULT")
    y3.timer.wait(1, function(timer)
        GameManager:remove_all_unit()
    end)

    GameManager:reset_game_state()
    UIManager:show_ui("RESULT")
end

function result:update()
    if GameManager:is_all_ready() then
        UIManager:hide_ui("RESULT")
        StateManager:set_state("MAINGAME")
    end
end

function result:exit()

end

return result
