local panel = {}

local function get_ui(player, name)
    return y3.ui.get_ui(player, name)
end

local function init(player)
    local btn = y3.ui.get_ui(player, 'prepare_stage.root.btn_ready')
    btn:add_local_event('左键-点击', function(local_player)
        local id = local_player:get_id()
        local_player:display_info(id .. " 准备完毕")
        y3.sync.send("player_ready", {})
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
        for i = 1, 4 do
            if GameManager.player_ready[i] then
                y3.ui.get_ui(local_player, 'prepare_stage.root.pos_' .. i):set_visible(true)
            else
                y3.ui.get_ui(local_player, 'prepare_stage.root.pos_' .. i):set_visible(false)
            end
        end
    end)
end

return panel
