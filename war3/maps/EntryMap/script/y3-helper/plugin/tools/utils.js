let y3 = require('y3-helper')

exports.getExcelJson = async function (uri) {
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
            } else if (types[j] == 'string') {
                obj[keys[j]] = value;
            }

        }
        list.push(obj);
    }
    y3.print(JSON.stringify(list))
    return list;
}
