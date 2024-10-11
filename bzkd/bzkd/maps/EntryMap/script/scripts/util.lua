local M = {}
function M:getTableLength(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function M:randomValueInTable(t)
    local tmpKeyT={}
    local n=1
    for k in pairs(t) do
        tmpKeyT[n]=k
        n=n+1
    end
    math.randomseed(os.time())
    return t[tmpKeyT[math.random(1,n-1)]]
end
return M