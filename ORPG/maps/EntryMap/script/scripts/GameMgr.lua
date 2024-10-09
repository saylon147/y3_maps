include 'scripts.GlobalVar'
local entry = require 'scripts.entry'
local picking = require 'scripts.gamePicking'
local const = require 'scripts.const'
local GameMgr = {}
function GameMgr:gameInit()
    GlobalVar["gameState"] = const.gameState['gamePrepage']
    entry:init()
end

function GameMgr:gamePicking()
    GlobalVar["gameState"] = const.gameState['gamePicking']
    picking:init()
end

function GameMgr:gameStart()
    GlobalVar["gameState"] = const.gameState['gaming']
end
return GameMgr
