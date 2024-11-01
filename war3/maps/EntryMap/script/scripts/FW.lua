--上方主要include运行时需要改变的物编类代码
include 'scripts.ability'
include 'scripts.ECA_lua_func'
--全局类 通过此类可以拿到所有相关的管理类和单例
FW = {}
FW.util = require 'scripts.util'
FW.globalVar = require 'scripts.config.GlobalVar'
FW.const = require 'scripts.config.GameConst'
FW.gameMgr = require 'scripts.mgr.GameMgr'
FW.playerMgr = require 'scripts.mgr.PlayerMgr'
FW.unitMgr = require 'scripts.mgr.UnitMgr'
FW.uiMgr = require 'scripts.mgr.UIMgr'
FW.configMgr = require 'scripts.mgr.ConfigMgr'
FW.itemMgr = require 'scripts.mgr.ItemMgr'
FW.shopMgr = require 'scripts.mgr.ShopMgr'
FW.mapMgr = require 'scripts.mgr.MapMgr'
