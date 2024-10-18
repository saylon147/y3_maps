local panel = {}

local hero_id = { 134219010, 134270560 }

local function get_ui(player, name)
    return y3.ui.get_ui(player, name)
end

local function init(player)
    local btn = y3.ui.get_ui(player, 'prepare_stage.root.center.btn_ready')
    btn:add_local_event('左键-点击', function(local_player)
        -- local id = local_player:get_id()
        -- local_player:display_info(id .. " 准备完毕")
        y3.sync.send("sync_data", { msg = "ready" })
    end)

    for i = 1, 2 do
        local btn = y3.ui.get_ui(player, 'prepare_stage.root.center.layout_1.sel_hero_' .. i)
        btn:add_local_event('左键-点击', function(local_player)
            y3.sync.send("sync_data", { msg = "sel_hero", id = hero_id[i] })
        end)
    end
end

------------------------------------------------------

function panel:show_ui(player, ui_name)
    local ui = get_ui(player, ui_name)
    ui:set_visible(true)
    init(player)
end

function panel:hide_ui(player, ui_name)
    local ui = get_ui(player, ui_name)
    ui:set_visible(false)
end

function panel:update()
    y3.player.with_local(function(local_player)
        for i = 1, GameManager.default_player_cnt do
            if GameManager.players[i].ready then
                y3.ui.get_ui(local_player, 'prepare_stage.root.center.layout_2.pos_' .. i):set_visible(true)
            else
                y3.ui.get_ui(local_player, 'prepare_stage.root.center.layout_2.pos_' .. i):set_visible(false)
            end
        end
    end)
end

return panel
