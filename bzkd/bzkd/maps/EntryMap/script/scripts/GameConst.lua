local GameConst = {}
GameConst.gameState = {
    gamePrepage = 1,    --准备阶段
    gamePicking = 2,    --选人阶段
    gaming = 3,         --游戏中
    result = 4,         --游戏结算
}
GameConst.maxPlayer = 4 --最大玩家数
return GameConst
