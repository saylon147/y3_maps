local M = {}
function M:getTableLength(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

function M:randomValueInTable(t)
    local tmpKeyT = {}
    local n = 1
    for k in pairs(t) do
        tmpKeyT[n] = k
        n = n + 1
    end
    math.randomseed(os.time())
    return t[tmpKeyT[math.random(1, n - 1)]]
end

function M:strToTable(str, sep)
    local result = {}
    if str == nil or sep == nil or type(str) ~= "string" or type(sep) ~= "string" then
        return result
    end
    if string.len(sep) == 0 then
        return result
    end
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(str, pattern, function(c)
        result[#result + 1] = c
    end)
    return result
end

function M:clamp(value, min, max)
    return math.max(min, math.min(value, max))
end




return M
