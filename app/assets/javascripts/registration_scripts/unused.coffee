window.set_value_to_object_key = (obj, key, val, except_keys)->
  original_obj = obj

  target = obj
  key_parts = key.split(".")
  i = 0
  last_key = key_parts[key_parts.length - 1]
  is_array = last_key.endsWith("[]")



  for key_part in key_parts
    if i < key_parts.length - 1
      key_part_name = key_part
      if key_part_name.endsWith("[]")
        key_part_name = key_part_name.substr(0, key_part_name.length - 2)
        if !target[key_part_name]
          target[key_part_name] = []
          target = target[key_part_name]
      else
        target = target[key_part_name]

    i++

  if Array.isArray(target)
    target.push(val)
  else
    target[last_key] = val


  obj
