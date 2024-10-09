local const = require 'scripts.const'
local M = {}
local heroTypes = {
    134274912,
    134241735,
    134219749,
    134240279,
    134222661,
    134275571,
}
local currentModelIndex = 1
local currentUnit
local localPlayer
local born_point = y3.point.create(0, 0, 200)
function M:init()
    localPlayer = y3.player.get_by_handle(GameAPI.get_client_role())
    currentUnit = y3.unit.create_unit(localPlayer, heroTypes[1], born_point, 0)
end

y3.game:event("键盘-按下", y3.const.KeyboardKey["LEFTARROW"], function(trg, data)
    if GlobalVar["gameState"] == const.gameState['gamePicking'] then
        if (currentModelIndex - 1 >= 1) then
            currentModelIndex = currentModelIndex - 1
        else
            return
        end
        currentUnit:remove()
        currentUnit = y3.unit.create_unit(localPlayer, heroTypes[currentModelIndex], born_point, 0)
    end
end)

y3.game:event("键盘-按下", y3.const.KeyboardKey["RIGHTARROW"], function(trg, data)
    if GlobalVar["gameState"] == const.gameState['gamePicking'] then
        if (currentModelIndex + 1 <= #heroTypes) then
            currentModelIndex = currentModelIndex + 1
        else
            return
        end
        currentUnit:remove()
        currentUnit = y3.unit.create_unit(localPlayer, heroTypes[currentModelIndex], born_point, 0)
    end
end)

y3.game:event("键盘-按下", y3.const.KeyboardKey["ENTER"], function(trg, data)
    if GlobalVar["gameState"] == const.gameState['gamePicking'] then
        local camera = y3.camera.get_by_handle(9999)
        camera:apply(localPlayer)
        camera.enable_camera_move(localPlayer)
        GameMgr:gameStart()
    end
end)

return M
