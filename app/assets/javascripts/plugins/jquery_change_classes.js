$.fn.changeClasses = function(add_classes, remove_classes){
    var any_changed = false
    if (!remove_classes){
      remove_classes = []
    }

    $(this).each(function(index, element){
        if (typeof add_classes == 'string'){
            add_classes = add_classes.split(" ").getUnique()
        }

        if (typeof remove_classes == 'string'){
            remove_classes = remove_classes.split(" ").getUnique()
        }

        var classes_str = element.classList.toString()
        var classes = classes_str.split(" ")
        var diff = false
        var new_classes = []
        var new_class_str = classes.concat(add_classes).getUnique().filter(function(c){ return !remove_classes.includes(c) }).join(" ")

        //console.log("new_class_str:", new_class_str, "; original_class_str:", classes_str)
        var changed = new_class_str != classes_str
        if (changed){
            $(element).attr("class", new_class_str)
        }

        if (changed){
            any_changed = true
        }
    })

    return any_changed



    var classes_to_remove = []
    var classes_to_add = []

    if (!add_classes){
        add_classes = []
    }

    if (!remove_classes){
        remove_classes = []
    }


    if (add_classes.length) {
        for (ac in add_classes) {
            if (!remove_classes.includes(ac) && !classes_to_add.includes(ac)) {
                classes_to_add.push(ac)
            }
        }
    }

    if ( remove_classes.length){
        for (rc in remove_classes){
            if (classes_to_add.includes(rc)){
                classes_to_remove.push(rc)
            }
        }
    }

    diff = classes_to_add.length > 0 || classes_to_remove.length > 0

    for(c in classes){
        if (!classes_to_remove.includes(c)){

            new_classes.push(c)
        }
    }

    for(c in classes_to_add){
        new_classes.push(c)
    }

    if (diff){
        this.classList = new_classes
    }
}