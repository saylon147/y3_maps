
---@class gameConst
local gameConst = Class 'gameConst'
---@enum(key) FW.gameConst.gameState
gameConst.gameState = {
    none = 1,
    gamePrepage = 2,    --准备阶段
    gamePicking = 3,    --选人阶段
    gaming = 4,         --游戏中
    result = 5,         --游戏结算
}
gameConst.bornPoint = {
    y3.point.get_point_by_res_id(10008),
    y3.point.get_point_by_res_id(10009),
    y3.point.get_point_by_res_id(10010),
    y3.point.get_point_by_res_id(10011)
}
gameConst.enemyBornPoint = {
    y3.point.get_point_by_res_id(10012),
    y3.point.get_point_by_res_id(10013),
    y3.point.get_point_by_res_id(10014),
    y3.point.get_point_by_res_id(10015)
}
-- gameConst.playerCamera = {
--     y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
--     y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
--     y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
--     y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
-- }
-- gameConst.enemyRandomArea = {
--     y3.area.get_by_res_id(10002),
--     y3.area.get_by_res_id(10003),
--     y3.area.get_by_res_id(10004),
--     y3.area.get_by_res_id(10005),
-- }

-- gameConst.roundTime = 60
-- gameConst.enemyCount = 3
-- gameConst.enemyBornTimeOut = 5
-- gameConst.maxHeroWeaponCount = 6
return gameConst
