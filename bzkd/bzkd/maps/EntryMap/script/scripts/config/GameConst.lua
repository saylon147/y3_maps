local GameConst = {}
GameConst.gameState = {
    gamePrepage = 1,    --准备阶段
    gamePicking = 2,    --选人阶段
    gaming = 3,         --游戏中
    result = 4,         --游戏结算
}
GameConst.playerCamera = {
    y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
    y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
    y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
    y3.camera.create_camera(y3.point.create(0,0,0),3000,35,0,56,10000),
}
GameConst.enemyRandomArea = {
    y3.area.get_by_res_id(10002),
    y3.area.get_by_res_id(10003),
    y3.area.get_by_res_id(10004),
    y3.area.get_by_res_id(10005),
}
GameConst.bornPoint = {
    GameConst.enemyRandomArea[1]:get_center_point(),
    GameConst.enemyRandomArea[2]:get_center_point(),
    GameConst.enemyRandomArea[3]:get_center_point(),
    GameConst.enemyRandomArea[4]:get_center_point(),
}
GameConst.heroWeaponAngle = {
    [1] = 0,
    [2] = 45,
    [3] = 90,
    [4] = 135,
    [5] = 180,
    [6] = 270,
}

GameConst.roundTime = 60
GameConst.enemyCount = 3
GameConst.enemyBornTimeOut = 5
return GameConst
