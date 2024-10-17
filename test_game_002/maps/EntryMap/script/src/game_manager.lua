--
GameManager = {
    players = {},

    isAllReady = function(self)
        for i = 1, self.default_player_cnt do
            if not self.players[i].ready then
                return false
            end
        end
        return true
    end,

    game_result = "init",

    -- DEFAULT
    default_player_cnt = 4,
    default_hero_id = 134219010,

}


function GameManager:init()
    for i = 1, self.default_player_cnt do
        self.players[i] = {
            ready = false,
            hero_id = 0,
            kill_cnt = 0,
        }
    end
end

return GameManager
