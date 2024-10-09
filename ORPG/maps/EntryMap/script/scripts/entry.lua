local startPanel = require 'scripts.ui.startPanel'
local const = require 'scripts.const'
local M = {}

function M:init()
    --y3.sync.send(const.syncEnum.newPlayer)
    startPanel:uiInit()
    -- local localPlayer = y3.player.get_by_handle(GameAPI.get_client_role())
    -- local camera = y3.camera.get_by_handle(10000)
    -- camera:apply(localPlayer)
    -- camera.disable_camera_move(localPlayer)
    local playerCount = 0
    for i = 1, const.maxPlayer, 1 do
        if y3.player.get_by_id(i) ~= nil then
            playerCount = playerCount + 1
        end
    end
    GlobalVar["playerCount"] = playerCount
end

-- y3.sync.onSync(const.syncEnum.newPlayer, function(data, source)
--     if GlobalVar["gameState"] == const.gameState['gamePrepage'] then
--         if source:get_id() ~= GameAPI.get_client_role():get_role_id_num() then
--             GlobalVar["playerGourp"]:add_player(source)
--         end
--     end
-- end)

return M
