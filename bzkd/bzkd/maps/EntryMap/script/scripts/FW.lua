--全局类 通过此类可以拿到所有相关的管理类和单例
FW = {}
FW.globalVar = require 'scripts.config.GlobalVar'
FW.const = require 'scripts.config.GameConst'
FW.gameMgr = require 'scripts.mgr.GameMgr'
FW.unitMgr = require 'scripts.mgr.UnitMgr'