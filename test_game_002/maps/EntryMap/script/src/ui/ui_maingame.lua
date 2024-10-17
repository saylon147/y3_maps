local panel = {}

local function get_ui(player, name)
    return y3.ui.get_ui(player, name)
end

local function init(player)
    for i = 1, GameManager.default_player_cnt do
        y3.ui.get_ui(player, 'maingame.root.player_state_scrollview.Player_State_' .. i)
            :set_visible(GameManager.players[i].exist)
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
            if GameManager.players[i].exist then
                y3.ui.get_ui(local_player, 'maingame.root.player_state_scrollview.Player_State_'
                    .. i .. ".kill_cnt"):set_text("Kill:" .. GameManager.players[i].kill_cnt)
            end
        end
    end)
end

return panel
