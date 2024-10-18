local prepare = {}

function prepare:enter()
    -- print("进入 PREPARE ")
    UIManager:show_ui("PREPARE")
end

function prepare:update()
    if GameManager:is_all_ready() then
        UIManager:hide_ui("PREPARE")
        StateManager:set_state("MAINGAME")
    end
end

function prepare:exit()

end

return prepare
