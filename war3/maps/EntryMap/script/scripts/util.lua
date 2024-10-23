---工具类
local util = {}
---获取lua table长度，主要是用来拿字典类的table长度
---@param t table
---@return number count
function util:getTableLength(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end
---随机一个table内的元素
---@param t table
---@return any obj
function util:randomValueInTable(t)
    local tmpKeyT = {}
    local n = 1
    for k in pairs(t) do
        tmpKeyT[n] = k
        n = n + 1
    end
    math.randomseed(os.time())
    return t[tmpKeyT[math.random(1, n - 1)]]
end

---将一个字符串转为table，spilt函数功能
---@param str string 源字符串
---@param sep string 分隔符
---@return any obj
function util:strToTable(str, sep)
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

---同unity clamp功能
---@param value number
---@param min number
---@param max number
---@return number result
function util:clamp(value, min, max)
    return math.max(min, math.min(value, max))
end




return util
