include 'scripts.ability'
--全局类 通过此类可以拿到所有相关的管理类和单例
FW = {}
FW.util = require 'scripts.util'
FW.globalVar = require 'scripts.config.GlobalVar'
FW.const = require 'scripts.config.GameConst'
FW.gameMgr = require 'scripts.mgr.GameMgr'
FW.playerMgr = require 'scripts.mgr.PlayerMgr'
FW.unitMgr = require 'scripts.mgr.UnitMgr'
FW.uiMgr = require 'scripts.mgr.UIMgr'
