let y3 = require('y3-helper')
let util = require('./utils')

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
        let list = await util.getExcelJson(uri);
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