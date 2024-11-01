let y3 = require('y3-helper')

export async function 读取item表格并生成修改物编() {
    //读表写入js对象
    const uri = y3.uri(y3.env.pluginUri, 'tools/config/item.xlsx')
    let list = await getExcelJson(uri);
    //修改物编json
    let itemTable = y3.table.openTable('物品')
    for (let obj of list) {
        let item = await itemTable.get(obj.id);
        item.data.name = obj.name;
        item.data.description = obj.desc;
        if (obj.item_type == 'ability') {
            item.data.attached_ability = [obj.ability_key, 1]
        }
    }
    //生成item lua文件
    for (let obj of list) {
        const uri = y3.uri(y3.env.scriptUri, 'scripts/item/' + obj.item_type + "/item_" + obj.lua_name + ".lua");
        let isExist = await y3.fs.isExists(uri)
        if (isExist) {
            await y3.fs.removeFile(uri);
        }
        let luaText = `--${obj.name}
local M = {}`
        for (let key in obj) {
            if (obj[key]) {
                if (typeof obj[key] == "string") {
                    luaText += `\nM.${key} = '${obj[key]}'`
                } else {
                    luaText += `\nM.${key} = ${obj[key]}`
                }

            }
        }
        luaText += '\nM.template = y3.object.item[M.id] --物编信息\n'
        if (obj.item_type != 'ability') {
            switch (obj.item_type) {
                case 'attr':
                    luaText += `\nM.template:event('物品-获得',function (trg, data)
    local buffs = FW.configMgr:getConfigTableRowByKey('buff','buff_name',M.effcct_buff)
    local buff = nil
    if #buffs > 0 then
        buff = buffs[1]
    end
    if buff then
        data.unit:add_buff({ key = buff.id, time = buff.timeout })
    end
    data.unit:add_attr(M.attr_name,M.attr_value)
    data.item:remove()
end)`;
                    break;
                case 'enemy':
                    luaText += `\nM.template:event('物品-获得',function (trg, data)
   local buffs = FW.configMgr:getConfigTableRowByKey('buff','buff_name',M.effcct_buff)
    local buff = nil
    if #buffs > 0 then
        buff = buffs[1]
    end
    if buff then
        data.unit:add_buff({ key = buff.id, time = buff.timeout })
    end
    local player = data.unit:get_owner();
    local enemy_count = tonumber(player:kv_load('enemy_count','string'))
    for i = 1, enemy_count, 1 do
        local unit = FW.unitMgr:createUnit(player,'enemy',nil,M.name,FW.const.enemyBornPoint[player:get_id()])
        unit:attack_move(FW.const.bornPoint[player:get_id()])
    end
    data.item:remove()
end)
`;
                    break;
                case 'followHero':
                    luaText += `\nM.template:event('物品-获得', function(trg, data)
    local buffs = FW.configMgr:getConfigTableRowByKey('buff','buff_name',M.effcct_buff)
    local buff = nil
    if #buffs > 0 then
        buff = buffs[1]
    end
    if buff then
        data.unit:add_buff({ key = buff.id, time = buff.timeout })
    end
    local player = data.unit:get_owner();
    local point = data.unit:get_point();
    FW.unitMgr:createUnit(player, 'followHero', nil, M.name,point)
    data.item:remove()
end)`;
                    break;
                case 'kv':
                    luaText += `\nM.template:event('物品-获得',function (trg, data)
    local buffs = FW.configMgr:getConfigTableRowByKey('buff','buff_name',M.effcct_buff)
    local buff = nil
    if #buffs > 0 then
        buff = buffs[1]
    end
    if buff then
        data.unit:add_buff({ key = buff.id, time = buff.timeout })
    end
    local player = data.unit:get_owner();
    local value = M.kv_value
    if player:kv_has(M.kv_key) then
        value = value + tonumber(player:kv_load(M.kv_key,'string'))
    end
    player:kv_save(M.kv_key,tostring(value))
    data.item:remove()
end)`;
                    break;
                case 'randomAttr':
                    luaText += `\nM.template:event('物品-获得', function(trg, data)
    local attrs = FW.configMgr:getConfigTable(M.random_table)
    local rand = math.random(1, #attrs)
    local buffs = FW.configMgr:getConfigTableRowByKey('buff','buff_name',attrs[rand].effcct_buff)
    local buff = nil
    if #buffs > 0 then
        buff = buffs[1]
    end
    if buff then
        data.unit:add_buff({ key = buff.id, time = buff.timeout })
    end
    data.unit:add_attr(attrs[rand].attr_name, attrs[rand].attr_value)
    data.item:remove()
end)`;
                    break;
            }
        }
        luaText += `\n\n---@param owner Player
---@param point Point 点
---@return Item
function M:create(owner, point)
    return y3.item.create_item(point,self.id,owner)
end

return M`
        await y3.fs.writeFile(uri, '', luaText);
    }
    //生成配置信息
    let dir = await y3.fs.dir(y3.env.scriptUri, 'scripts/item')
    let templateStr = "\nitemMgr.itemTemplate = {\n"

    for (let i = 0; i < dir.length; i++) {
        let name = dir[i][0]
        let subDir = await y3.fs.dir(y3.env.scriptUri, 'scripts/item/' + name);
        for (let j = 0; j < subDir.length; j++) {
            let subName = subDir[j][0].replace(".lua", "");
            let cname = "";
            for (let item of list) {
                if('item_'+item.lua_name == subName){
                    cname = item.name
                }
            }
            templateStr += "\t['" + cname + "'] = require 'scripts.item." + name + "." + subName + "',\n";
        }
    }
    templateStr += "}\n";
    let oriText = (await y3.fs.readFile(y3.env.scriptUri, 'scripts/mgr/ItemMgr.lua')).string;
    let replaceText = oriText.split('---autocode---')[1];
    oriText = oriText.replace(replaceText, templateStr);
    await y3.fs.writeFile(y3.env.scriptUri, 'scripts/mgr/ItemMgr.lua', oriText);
}

async function getExcelJson(uri) {
    let sheet = await y3.excel.loadFile(uri)
    let keys = []
    let ids = []
    let list = []
    let types = []
    for (let i = 0; ; i++) {
        let key = sheet.cells[String.fromCharCode(65 + i) + '1']
        if (key) {
            keys.push(key);
        } else {
            break;
        }
    }
    for (let i = 0; ; i++) {
        let type = sheet.cells[String.fromCharCode(65 + i) + '3']
        if (type) {
            types.push(type);
        } else {
            break;
        }
    }
    for (let i = 4; ; i++) {
        let key = sheet.cells['A' + i]
        if (key) {
            ids.push(key);
        } else {
            break;
        }
    }
    let table = sheet.makeTable();
    for (let i = 0; i < ids.length; i++) {
        let obj = {};
        for (let j = 0; j < keys.length; j++) {
            let value = table[ids[i]][keys[j]];
            if (types[j] == 'int') {
                obj[keys[j]] = parseInt(value);
            } else if (types[j] == 'float') {
                obj[keys[j]] = Number(parseFloat(value).toFixed(2));
            } else if (types[j] == 'int[]') {
                let list = value.split("|");
                let newList = [];
                for (let z = 0; z < list.length; z++) {
                    newList[z] = parseInt(list[z]);
                }
                obj[keys[j]] = newList;
            } else if (types[j] == 'float[]') {
                let list = value.split("|");
                let newList = [];
                for (let z = 0; z < list.length; z++) {
                    newList[z] = Number(parseFloat(list[z]).toFixed(2));
                }
                obj[keys[j]] = newList;
            } else if (types[j] == 'string[]') {
                obj[keys[j]] = value.split("|");
            } else if (types[j] == 'string') {
                obj[keys[j]] = value;
            }

        }
        list.push(obj);
    }
    y3.print(JSON.stringify(list))
    return list;
}


