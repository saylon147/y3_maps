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
            exist = y3.player.get_by_id(i):get_state() == 1,
            ready = y3.player.get_by_id(i):get_state() ~= 1,
            hero_id = 0,
            kill_cnt = 0,
        }
    end


    y3.sync.onSync("sync_data", function(data, source)
        -- print(data, type(data))
        -- print(source, type(source))
        -- y3.player.with_local(function(local_player)
        --     local_player:display_info("sync from:" .. source:get_id() .. " data:" .. data["msg"])
        -- end)
        local idx = source:get_id()
        if data["msg"] == "ready" then
            self.players[idx].ready = true
            if self.players[idx].hero_id == 0 then
                self.players[idx].hero_id = self.default_hero_id
            end
        elseif data["msg"] == "sel_hero" then
            self.players[idx].hero_id = data["id"]
        elseif data["msg"] == "kill_unit" then
            self.players[idx].kill_cnt = self.players[idx].kill_cnt + data["cnt"]
        end
    end)
end

return GameManager
