
function value_props(obj){
    var obj2 = {}
    for(var k in obj ){
        if (typeof obj[k] != "function"){
            obj2[k] = obj[k]
        }

    }

    return obj2
}

function value_prop_keys(obj, name_not_prefix){
    var arr = []
    if (name_not_prefix && !name_not_prefix.length){
        name_not_prefix = null
    }

    for (var k in obj){
        if (typeof obj[k] != "function" && (!name_not_prefix || !k.startsWith(name_not_prefix))){
            arr.push(k)
        }
    }

    return arr.sort()
}

Array.prototype.getUnique = function(){
    var u = {}, a = [];
    for(var i = 0, l = this.length; i < l; ++i){
        if(u.hasOwnProperty(this[i])) {
            continue;
        }
        a.push(this[i]);
        u[this[i]] = 1;
    }
    return a;
}
