local panel = {}

local function get_ui(player, name)
    return y3.ui.get_ui(player, name)
end

local function init(player)
    local btn = y3.ui.get_ui(player, 'result.root.next_round_btn')
    btn:add_local_event('左键-点击', function(local_player)
        y3.sync.send("sync_data", { msg = "ready" })
    end)
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
                y3.ui.get_ui(local_player, 'result.root.layout_2.pos_' .. i):set_visible(true)
            else
                y3.ui.get_ui(local_player, 'result.root.layout_2.pos_' .. i):set_visible(false)
            end
        end
    end)
end

return panel
