--
GameManager = {
    player_ready = { false, false, false, false },
    isAllReady = function(self)
        for i = 1, #self.player_ready do
            if not self.player_ready[i] then
                return false
            end
        end
        return true
    end,


    player_kill = 0,
    game_result = "init",

}


return GameManager
