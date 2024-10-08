local prepare = {}

local prepare_ui = nil

function prepare:enter()
    print("进入 PREPARE")

    if not prepare_ui then
        prepare_ui = y3.ui.get_ui(GameManager.player, 'prepare_stage')
    end
    prepare_ui:set_visible(true)

    local btn = y3.ui.get_ui(GameManager.player, 'prepare_stage.root.btn_ready')
    btn:add_event('左键-点击', 'click_ready')
end

function prepare:update()
    if not prepare_ui then
        return
    end

    if GameManager.im_ready then
        prepare_ui:set_visible(false)
        StateManager:set_state("maingame")
    end
end

function prepare:exit()

end

y3.game:event('界面-消息', 'click_ready', function()
    print("准备完毕")
    GameManager.im_ready = true
end)

return prepare
