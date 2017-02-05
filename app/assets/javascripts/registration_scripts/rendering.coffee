window.render_inputs_to_string = (props, data = {})->
  res = ""
  for k, v of props
    type = v.type || "string"
    types_by_column_name = {password: "password", password_confirmation: "password", email: "email", phones: "phones"}
    type_by_column_name = types_by_column_name[k]
    type = type_by_column_name if !v.type && type_by_column_name
    #console.log "type: ", type
    prop_data = data[k]
    res += inputs[type].render(k, v, prop_data)

  res

window.column = (html_class, props, data)->
  s = render_inputs_to_string(props, data)
  "<div class='columns #{html_class}'>#{s}</div>"
