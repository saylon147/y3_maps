local result = {}

function result:enter()
    print("进入 RESULT")
    if GameManager.game_result == "win" then
        local ui = y3.ui.get_ui(GameManager.player, "win")
        ui:set_visible(true)
    else
        local ui = y3.ui.get_ui(GameManager.player, "loss")
        ui:set_visible(true)
    end
end

function result:update()

end

function result:exit()

end

return result
