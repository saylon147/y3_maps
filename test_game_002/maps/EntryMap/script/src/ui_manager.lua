--
UIManager = {
    ui = {
        PREPARE = { instance = require("src.ui.ui_prepare"), name = "prepare_stage", visible = false },
        MAINGAME = { instance = require("src.ui.ui_maingame"), name = "maingame", visible = false },
        RESULT = { instance = require("src.ui.ui_result"), name = "result", visible = false },
    },
}



function UIManager:init()

end

function UIManager:show_ui(ui_name)
    y3.player.with_local(function(local_player)
        local ui = self.ui[ui_name].instance
        ui:show_ui(local_player, self.ui[ui_name].name)
        self.ui[ui_name].visible = true
    end)
end

function UIManager:hide_ui(ui_name)
    y3.player.with_local(function(local_player)
        local ui = self.ui[ui_name].instance
        ui:hide_ui(local_player, self.ui[ui_name].name)
        self.ui[ui_name].visible = false
    end)
end

function UIManager:update()
    for _, ui_data in pairs(self.ui) do
        if ui_data.visible then
            ui_data.instance:update()
        end
    end
end

return UIManager
