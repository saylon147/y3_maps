local state_manager = {}

local cur_state = nil
local states = {
    prepare = require("states.prepare"),
    maingame = require("states.maingame"),
    result = require("states.result")
}

function state_manager.set_state(state_name)
    if states[state_name] then
        cur_state = states[state_name]
        cur_state.enter()
    else
        error("未知状态：" .. state_name)
    end
end

function state_manager.update()
    if cur_state and cur_state.update then
        cur_state.update()
    end
end

return state_manager
