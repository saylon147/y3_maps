let y3 = require('y3-helper')

export async function 读取unit表格并生成修改物编() {
    //读表写入js对象
    const uri = y3.uri(y3.env.pluginUri, 'tools/config/unit.xlsx')
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
                obj[keys[j]] = parseFloat(value);
            } else {
                obj[keys[j]] = value;
            }

        }
        list.push(obj);
    }
    y3.print(JSON.stringify(list))
    //修改物编json
    let unitTable = y3.table.openTable('单位')
    for (let item of list) {
        let unit = await unitTable.get(item.id);
        unit.data.name = item.cname;
        for (let key in item) {
            if (unit.data[key]) {
                unit.data[key] = item[key]
            }
        }
    }
    //生成unit lua文件
    for (let item of list) {
        // y3.fs.dir(y3.env.scriptUri,'scrips/unit')
        // y3.fs.
        // item.unit_type
    }
    //await y3.fs.writeFile(y3.env.scriptUri, 'log/演示Lua表.lua', 'return ' + luaCode + '\n')
}