---@class configMgr
local configMgr = Class 'configMgr'
configMgr.configs = require 'scripts.config.excel'

---@param tableName string
---@return table config
function configMgr:getConfigTable(tableName)
    return configMgr.configs[tableName]
end

---@param tableName string
---@param id integer
---@return table row
function configMgr:getConfigTableRowById(tableName, id)
    return configMgr.configs[tableName][id]
end

---@param tableName string
---@param key string
---@param value integer|string|number --不支持数组查询
---@return table rows
function configMgr:getConfigTableRowByKey(tableName, key, value)
    local source = configMgr.configs[tableName]
    local rows = {}
    for index, row in ipairs(source) do
        if row[key] == value then
            table.insert(rows,row)
        end
    end
    return rows
end

return configMgr
