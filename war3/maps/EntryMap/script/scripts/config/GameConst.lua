local gameConst = {}
---@enum(key) FW.gameConst.gameState
gameConst.gameState = {
    gamePrepage = 1,    --准备阶段
    gamePicking = 2,    --选人阶段
    gaming = 3,         --游戏中
    result = 4,         --游戏结算
}
gameConst.playerCamera = {
    y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
    y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
    y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
    y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
}
gameConst.enemyRandomArea = {
    y3.area.get_by_res_id(10002),
    y3.area.get_by_res_id(10003),
    y3.area.get_by_res_id(10004),
    y3.area.get_by_res_id(10005),
}
gameConst.bornPoint = {
    gameConst.enemyRandomArea[1]:get_center_point(),
    gameConst.enemyRandomArea[2]:get_center_point(),
    gameConst.enemyRandomArea[3]:get_center_point(),
    gameConst.enemyRandomArea[4]:get_center_point(),
}

gameConst.roundTime = 60
gameConst.enemyCount = 3
gameConst.enemyBornTimeOut = 5
gameConst.maxHeroWeaponCount = 6
return gameConst
