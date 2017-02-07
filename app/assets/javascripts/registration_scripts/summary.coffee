window.render_summary = (data)->
  user_info = {
    first_name: {}
    middle_name: {}
    last_name: {}
    birth_date: {}
    phones: {}
    email: {}
    personal_helpers: {}
  }

  company_info = {
    name: {}
    industry: {}
    description: {}
    #region: {}
    regions: {type: "regions"}
    position: {}
    employees_count: {}
    company_site: {type: "site"}
    offices: {}
#social_networks: {}
    social_facebook: {type: "social"}
    social_google_plus: {type: "social"}
  }

  user_info_str = ""
  company_info_str = ""
  for k, field_definition of user_info
    v = data.user[k]
    if !field_definition.type
      type = "string"
      type = k if summary_field_types[k] && summary_field_types[k].render
    else
      type = field_definition.type
    user_info_str += summary_field_types[type].render(k, v)

  for k, field_definition of company_info
    v = data.company[k]
    if !field_definition.type
      type = "string"
      type = k if summary_field_types[k] && summary_field_types[k].render
    else
      type = field_definition.type
    company_info_str += summary_field_types[type].render(k, v)


  s = "<div class='columns large-6'><div class='summary-header'>Основна інформація</div>#{user_info_str}</div><div class='columns large-6'><div class='summary-header'>Інформація про компанію</div>#{company_info_str}</div>"

  $("#registration-summary").html(s)

