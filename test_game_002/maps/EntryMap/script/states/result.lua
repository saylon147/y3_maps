local result = {}

function result:enter()
    print("进入 RESULT")
    local player = y3.player.get_by_handle(GameAPI.get_client_role())

    if GameManager.game_result == "win" then
        local ui = y3.ui.get_ui(player, "win")
        ui:set_visible(true)
    else
        local ui = y3.ui.get_ui(player, "loss")
        ui:set_visible(true)
    end
end

function result:update()

end

function result:exit()

end

return result
