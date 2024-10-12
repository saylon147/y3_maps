local prepare = {}

local prepare_ui = nil

function prepare:enter()
    print("进入 PREPARE ")

    y3.player.with_local(function(local_player)
        if not prepare_ui then
            prepare_ui = y3.ui.get_ui(local_player, 'prepare_stage')
        end
        prepare_ui:set_visible(true)

        local btn = y3.ui.get_ui(local_player, 'prepare_stage.root.btn_ready')
        btn:add_local_event('左键-点击', function(local_player)
            local id = local_player:get_id()
            local_player:display_info(id .. " 准备完毕")
            y3.sync.send("player_ready", {})
        end)
    end)
end

function prepare:update()
    if not prepare_ui then
        return
    end

    y3.player.with_local(function(local_player)
        for i = 1, 4 do
            if GameManager.player_ready[i] then
                y3.ui.get_ui(local_player, 'prepare_stage.root.pos_' .. i):set_visible(true)
            else
                y3.ui.get_ui(local_player, 'prepare_stage.root.pos_' .. i):set_visible(false)
            end
        end

        if GameManager:isAllReady() then
            -- prepare_ui:set_visible(false)
            StateManager:set_state("maingame")
        end
    end)
end

function prepare:exit()

end

-- y3.game:event('界面-消息', 'click_ready', function()
--     y3.player.with_local(function(local_player)
--         local id = local_player:get_id()
--         local_player:display_info(id .. " 准备完毕")
--         y3.sync.send("player_ready", {})
--     end)
-- end)

return prepare
