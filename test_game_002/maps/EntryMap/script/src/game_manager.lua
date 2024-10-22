--
GameManager = {
    players = {},

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
            heroes = {},
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

-- 是否所有玩家都准备好
function GameManager:is_all_ready()
    for i = 1, self.default_player_cnt do
        if not self.players[i].ready then
            return false
        end
    end
    return true
end

-- 是否达成了过关条件
function GameManager:is_reach_target()
    for i = 1, self.default_player_cnt do
        if self.players[i].kill_cnt >= 10 then
            return true
        end
    end
    return false
end

function GameManager:stop_all_heroes()
    for i = 1, self.default_player_cnt do
        for j = 1, #self.players[i].heroes do
            self.players[i].heroes[j]:add_state("无法控制")
        end
    end
end

function GameManager:recover_all_heroes()
    for i = 1, self.default_player_cnt do
        for j = 1, #self.players[i].heroes do
            self.players[i].heroes[j]:remove_state("无法控制")
        end
    end
end

-- 重置状态
function GameManager:reset_game_state()
    for i = 1, self.default_player_cnt do
        if self.players[i].exist then
            self.players[i].ready = false
            self.players[i].kill_cnt = 0
        end
    end
end

-- 删除单位
function GameManager:remove_all_unit()
    for i = 1, self.default_player_cnt do
        if self.players[i].exist then
            UnitManager:remove_all_unit(y3.player.get_by_id(i))
        end
    end

    -- 那个刷怪的塔创建给31了
    UnitManager:remove_all_unit(y3.player.get_by_id(31))
end

return GameManager
