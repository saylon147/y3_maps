let y3 = require('y3-helper')

//要先运行item的
export async function 读取shop表格并生成修改物编() {
    //读表写入js对象
    const uri = y3.uri(y3.env.pluginUri, 'tools/config/shop.xlsx')
    let list = await getExcelJson(uri);
    //修改物编json
    let unitTable = y3.table.openTable('单位')
    for (let obj of list) {
        let item = await unitTable.get(obj.id);
        item.data.name = obj.name;
        item.data.description = obj.desc;
    }
    //生成item lua文件
    for (let obj of list) {
        const uri = y3.uri(y3.env.scriptUri, 'scripts/shop/' + "/shop_" + obj.lua_name + ".lua");
        let isExist = await y3.fs.isExists(uri)
        if (isExist) {
            await y3.fs.removeFile(uri);
        }
        let luaText = `--${obj.name}
local M = {}`
        for (let key in obj) {
            if (key.indexOf("items")== -1) {
                if (typeof obj[key] == "string") {
                    luaText += `\nM.${key} = '${obj[key]}'`
                } else {
                    luaText += `\nM.${key} = ${obj[key]}`
                }
            }
        }
        if (obj.items != null) {

        }
        luaText += '\nM.template = y3.object.item[M.id] --物编信息\n'

        luaText += `\n\n---@param owner Player|Unit
---@param point Point 点
---@param direction number 方向
---@return Unit
function M:create(owner, point, direction)
    local unit = y3.unit.create_unit(owner, self.id, point, direction)
    return unit
end
return M`
        await y3.fs.writeFile(uri, '', luaText);
    }
    //生成配置信息
    // let dir = await y3.fs.dir(y3.env.scriptUri, 'scripts/item')
    // let templateStr = "\nitemMgr.itemTemplate = {\n"

    // for (let i = 0; i < dir.length; i++) {
    //     let name = dir[i][0]
    //     let subDir = await y3.fs.dir(y3.env.scriptUri, 'scripts/item/' + name);
    //     for (let j = 0; j < subDir.length; j++) {
    //         let subName = subDir[j][0].replace(".lua", "");
    //         let cname = "";
    //         for (let item of list) {
    //             if('item_'+item.lua_name == subName){
    //                 cname = item.name
    //             }
    //         }
    //         templateStr += "\t['" + cname + "'] = require 'scripts.item." + name + "." + subName + "',\n";
    //     }
    // }
    // templateStr += "}\n";
    // let oriText = (await y3.fs.readFile(y3.env.scriptUri, 'scripts/mgr/ItemMgr.lua')).string;
    // let replaceText = oriText.split('---autocode---')[1];
    // oriText = oriText.replace(replaceText, templateStr);
    // await y3.fs.writeFile(y3.env.scriptUri, 'scripts/mgr/ItemMgr.lua', oriText);
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
                if(value == "" || value == null){
                    obj[keys[j]] = null
                } else {
                    let list = value.split("|");
                    let newList = [];
                    for (let z = 0; z < list.length; z++) {
                        newList[z] = parseInt(list[z]);
                    }
                    obj[keys[j]] = newList;
                }

            } else if (types[j] == 'float[]') {
                if(value == "" || value == null){
                    obj[keys[j]] = null
                } else {
                    let list = value.split("|");
                    let newList = [];
                    for (let z = 0; z < list.length; z++) {
                        newList[z] = Number(parseFloat(list[z]).toFixed(2));
                    }
                    obj[keys[j]] = newList;
                }
            } else if (types[j] == 'string[]') {
                if(value == "" || value == null){
                    obj[keys[j]] = null
                } else {
                    obj[keys[j]] = value.split("|");
                }
            } else if (types[j] == 'string') {
                obj[keys[j]] = value;
            }

        }
        list.push(obj);
    }
    y3.print(JSON.stringify(list))
    return list;
}


