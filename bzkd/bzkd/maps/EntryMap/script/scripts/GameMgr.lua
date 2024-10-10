local startPanel = require 'scripts.ui.startPanel'
GameMgr = {}
GameMgr.globalVar = require 'scripts.GlobalVar'
GameMgr.const = require 'scripts.GameConst'
function GameMgr:gameInit()
    GameMgr.globalVar["gameState"] = GameMgr.const.gameState['gamePrepage']
    startPanel:initUI()
end

function GameMgr:gamePicking()
    GameMgr.globalVar["gameState"] = GameMgr.const.gameState['gamePicking']
end

function GameMgr:gameStart()
    GameMgr.globalVar["gameState"] = GameMgr.const.gameState['gaming']
end

return GameMgr
