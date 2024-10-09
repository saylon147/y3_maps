local M = {}
local prepareTime = 20
local currentTime = 20
local ui = y3.local_ui.create("选择章节")
local born_point = y3.point.create(0, 0, 200)

-- local function vote(roleId, chapterId)
--     --GlobalVar.vote[roleId] = chapterId
--     y3.player.get_by_id(roleId):create_unit(134274912, born_point)
--     -- ui:refresh('')
-- end

local function vote(roleId, chapterId)
    -- GlobalVar.vote[roleId] = chapterId
    -- y3.player.get_by_id(1):create_unit(134274912, born_point)
    -- y3.player.get_by_id(2):create_unit(134274912, born_point)
    -- ui:refresh('')
end

function M:uiInit()
    ui:on_init('', function(ui, local_player)
        ui:set_visible(true)
        ui.play_timeline_animation(local_player, "startAnim", 0.5)
    end)
    ui:on_event('button_1', '左键-按下', function(ui, local_player)
        vote(local_player:get_id(), 1)
        ui:get_parent():set_visible(false)
        y3.sync.send("vote",1)
    end)
    ui:on_event('button_1_1', '左键-按下', function(ui, local_player)
        vote(local_player:get_id(), 2)
        ui:get_parent():set_visible(false)
        y3.sync.send("vote",2)
    end)

    -- ui:on_refresh('', function(ui, local_player)
    --     local hasPick = false
    --     for key, value in pairs(GlobalVar.vote) do
    --         if key==local_player:get_id() then
    --             hasPick = true
    --         end
    --     end
    --     if hasPick then
    --         ui:set_visible(false)
    --     end
    -- end)
    -- ui:on_refresh('timerBg.timer', function(ui, local_player)
    --     ui:set_text(tostring(currentTime))
    --     if (currentTime <= 0) then
    --         local hasPick = false
    --         for key, value in pairs(GlobalVar.vote) do
    --             if key==local_player:get_id() then
    --                 hasPick = true
    --             end
    --         end
    --         if ~hasPick then
    --             vote(local_player:get_id(), 1)
    --         end
    --     end
    -- end)
    -- y3.timer.wait(1, function(timer)
    --     y3.timer.loop(1, function(timer, count)
    --         currentTime = prepareTime - count
    --         if currentTime <= 0 then
    --             timer:remove()
    --         end
    --         ui:refresh('timerBg.timer')
    --     end, "游戏开始倒计时", true)
    --     timer:remove()
    -- end)
end

return M
