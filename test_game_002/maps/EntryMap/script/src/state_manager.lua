--
StateManager = {
    current_state = nil,
    states = {
        PREPARE = require("src.state.prepare"),
        MAINGAME = require("src.state.maingame"),
        RESULT = require("src.state.result"),
    }
}


-- 设置当前状态
function StateManager:set_state(state_name)
    if self.states[state_name] then
        if self.current_state and self.current_state.exit then
            self.current_state:exit()
        end
        self.current_state = self.states[state_name]
        if self.current_state.enter then
            self.current_state:enter()
        end
    else
        error("尝试切换到未知状态: " .. state_name)
    end
end

-- 更新当前状态
function StateManager:update()
    if self.current_state and self.current_state.update then
        self.current_state:update()
    end
end

return StateManager
