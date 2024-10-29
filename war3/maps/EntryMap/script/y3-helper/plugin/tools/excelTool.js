let y3 = require('y3-helper')

export async function 读取unit表格并生成修改物编() {
    //读表写入js对象
    const uri = y3.uri(y3.env.pluginUri, 'tools/config/unit.xlsx')
    let list = await getExcelJson(uri);
    //修改物编json
    let unitTable = y3.table.openTable('单位')
    for (let item of list) {
        let unit = await unitTable.get(item.id);
        for (let key in item) {
            if (unit.data[key] != null) {
                unit.data[key] = item[key];
            }else if(key != 'id'){
                let kv = unit.data.kv
                kv[key] = item[key]
                unit.data.kv = kv
            }
        }
    }
    //生成unit lua文件
    for (let item of list) {
        const uri = y3.uri(y3.env.scriptUri, 'scripts/unit/' + item.unit_type + "/" + item.lua_name + ".lua");
        let isExist = await y3.fs.isExists(uri)
        let oriText = ""
        if (isExist) {
            oriText = (await y3.fs.readFile(y3.env.scriptUri, 'scripts/unit/' + item.unit_type + "/" + item.lua_name + ".lua")).string;
        }
        let luaText = "";
        if (oriText.indexOf('---not refresh code---') != -1) {
            let replaceText = oriText.split('---not refresh code---')[1];
            luaText = `--${item.name}
            local M = {}
            M.id = ${item.id}
            M.template = y3.object.unit[M.id] --物编信息
            M.type = '${item.unit_type}'
            ---not refresh code---
            ${replaceText}
            ---not refresh code---
            ---@param owner Player|Unit
            ---@param point Point 点
            ---@param direction number 方向
            ---@return Unit
            function M:create(owner, point, direction)
                local unit = y3.unit.create_unit(owner, self.id, point, direction)
                addAbilitys(unit)
                return unit
            end
            return M`
        } else {
            luaText = `--${item.name}
            local M = {}
            M.id = ${item.id}
            M.template = y3.object.unit[M.id] --物编信息
            M.type = '${item.unit_type}'
            ---not refresh code---
            M.template:event("单位-死亡",function (trg, data)
                
            end)
            
            ---@param unit Unit
            local function addAbilitys(unit)
                
            end
            ---not refresh code---
            ---@param owner Player|Unit
            ---@param point Point 点
            ---@param direction number 方向
            ---@return Unit
            function M:create(owner, point, direction)
                local unit = y3.unit.create_unit(owner, self.id, point, direction)
                addAbilitys(unit)
                return unit
            end
            return M`
        }

        await y3.fs.writeFile(uri, '', luaText);
    }
    //生成配置信息
    let dir = await y3.fs.dir(y3.env.scriptUri, 'scripts/unit')
    let templateStr = "\nunitMgr.unitTemple = {\n"

    for (let i = 0; i < dir.length; i++) {
        let name = dir[i][0]
        let subDir = await y3.fs.dir(y3.env.scriptUri, 'scripts/unit/' + name);
        templateStr += "\t---@enum(key) FW.unitMgr." + name + "UnitType\n";
        templateStr += "\t" + name + "= {\n";
        for (let j = 0; j < subDir.length; j++) {
            let subName = subDir[j][0].replace(".lua", "");
            let cname = "";
            for (let item of list) {
                if (item.lua_name == subName && item.unit_type == name) {
                    cname = item.name
                }
            }
            templateStr += "\t['" + cname + "'] = require 'scripts.unit." + name + "." + subName + "',\n";
        }
        templateStr += "\t},\n";
    }
    templateStr += "\t}\n";
    let oriText = (await y3.fs.readFile(y3.env.scriptUri, 'scripts/mgr/UnitMgr.lua')).string;
    let replaceText = oriText.split('---autocode---')[1];
    oriText = oriText.replace(replaceText, templateStr);
    await y3.fs.writeFile(y3.env.scriptUri, 'scripts/mgr/UnitMgr.lua', oriText);
}

export async function 读取所有excel表格并生成lua配置表() {
    let dir = await y3.fs.dir(y3.env.scriptUri, 'scripts/config/excel');
    for (let i = 0; i < dir.length; i++) {
        await y3.fs.removeFile(y3.env.scriptUri, 'scripts/config/excel/' + dir[i][0], { recursive: true })
    }
    let oriDir = await y3.fs.dir(y3.env.pluginUri, 'tools/config')
    let configs = {}
    for (let i = 0; i < oriDir.length; i++) {
        //读表写入js对象
        const uri = y3.uri(y3.env.pluginUri, 'tools/config/' + oriDir[i][0])
        let list = await getExcelJson(uri);
        let luaText = "local M = {\n";
        for (let j = 0; j < list.length; j++) {
            luaText += `[${j + 1}] = {`
            for (let key in list[j]) {
                if (Array.isArray(list[j][key])) {
                    if (list[j][key].length > 0) {
                        luaText += `${key} = {`;
                        for (let k = 0; k < list[j][key].length; k++) {
                            if (typeof list[j][key][k] === 'number') {
                                luaText += `${list[j][key][k]},`
                            } else if (typeof list[j][key][k] == 'string') {
                                luaText += `'${list[j][key][k]}',`
                            }
                            if (k == list[j][key].length - 1) {
                                luaText = luaText.substring(0, luaText.length - 1)
                            }
                        }
                        luaText += "},";
                    } else {
                        luaText += `${key} = {},`
                    }
                } else {
                    if (typeof list[j][key] === 'number') {
                        luaText += `${key} = ${list[j][key]},`
                    } else if (typeof list[j][key] == 'string') {
                        luaText += `${key} = '${list[j][key]}',`
                    }
                }
            }
            luaText += '},\n';
        }
        luaText += "}\nreturn M";
        let fileName = oriDir[i][0].replace(".xlsx", '');
        y3.fs.writeFile(y3.env.scriptUri, 'scripts/config/excel/' + fileName + ".lua", luaText);
        configs[fileName] = 'scripts/config/excel/' + fileName;
    }
    y3.print(JSON.stringify(configs));
    //生成配置表入口文件
    let initLuaText = "local config = {\n";
    for(let key in configs){
        initLuaText += `${key} = require '${configs[key].replaceAll("/",".")}',\n`;
    }
    initLuaText += "}\nreturn config"
    y3.fs.writeFile(y3.env.scriptUri, 'scripts/config/excel/init.lua', initLuaText);
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
                    newList[z] = Number(parseFloat(value).toFixed(2));
                }
                obj[keys[j]] = newList;
            } else if (types[j] == 'string[]') {
                obj[keys[j]] = value.split("|");
            } else if(types[j] == 'string'){
                obj[keys[j]] = value;
            }

        }
        list.push(obj);
    }
    y3.print(JSON.stringify(list))
    return list;
}