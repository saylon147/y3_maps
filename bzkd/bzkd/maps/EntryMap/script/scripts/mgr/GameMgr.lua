local startPanel = require 'scripts.ui.startPanel'
local M
function M:gameInit()
    FW.globalVar["gameState"] = FW.const.gameState['gamePrepage']
    startPanel:initUI()
end

function M:gamePicking()
    FW.globalVar["gameState"] = FW.const.gameState['gamePicking']
end

function M:gameStart()
    FW.globalVar["gameState"] = FW.const.gameState['gaming']
end

return M
