local panel = {}

local function get_ui(player, name)
    return y3.ui.get_ui(player, name)
end

local function init(player)

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

end

return panel
