check_if_cabinet = ()->
  $("body").hasClass("cabinet__index")


window.is_cabinet = check_if_cabinet()






render_inputs_to_string = (props, data = {})->
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

column = (html_class, props, data)->
  s = render_inputs_to_string(props, data)
  "<div class='columns #{html_class}'>#{s}</div>"

window.registration_user_form = column("medium-6", {
  first_name: {required: true, autocomplete: "given-name"}
  middle_name: {required: true, autocomplete: "additional-name"}
  last_name: {required: true, autocomplete: "family-name"},
  birth_date: {
    required: true
    type: "date"
  }
}) +
column( "medium-6", {
  phones: { required: true, min: 1 }
  email: {
    required: true
    email: true
    check_if_email_available: true
  }
  password: {
    required: true
    min_length: 8
  }
  password_confirmation: {
    required: true
    must_equal: "password"
  }
}) +
column("medium-12", {
  personal_helpers: {
    type: "personal_helpers"
  }
})






render_cabinet_user_form = (data)->
  form_str = column("medium-6", {
    first_name: {required: true}
    middle_name: {required: true}
    last_name: {required: true},
    birth_date: {
      required: true
      type: "date"
    }
    hobby: {
      type: "text"
    }
  }, data) +
  column( "medium-6", {
    phones: { required: true, min: 1 }
    email: {
      readonly: true
      help: "якщо хочете змінити email, звертайтесь до адміністратора"
    }
    password: {
      min_length: 8
      label: t("attributes.new_password")
    }
    password_confirmation: {
      must_equal: "password"
    }
    social_networks: { type: "social_networks", label: t("attributes.user_social_networks") }
    #social_facebook: {}
    #social_google_plus: {}
  }, data)

  save_title = t("save_profile")

  save_profile_control_str = "<div class='cabinet-profile-control cabinet-profile-control-save' title='#{save_title}'><div class='cabinet-profile-control-icon'>#{svg_images.check}</div><label class='cabinet-profile-control-label'>#{save_title}</label></div>"

  res = form_str + "<div class='cabinet-controls'>" + save_profile_control_str + "</div>"

  res


render_company_name_block = (company_name)->
  company_name = t("placeholders.name") if !company_name || !company_name.length
  "<div class='columns company-name-column'><div class='company-name'>#{company_name}</div></div>"

render_company_form = (data, render_controls = false)->
  data ?= {}
  company_name_str = render_company_name_block(data.name)
  window.available_industries ?= $(".cabinet-container, .registration-container").attr("data-available-industries").split(",")
  form_str = company_name_str +
  column("medium-6", {
    industry: {
      required: true
      type: "select_with_custom_value"
      select_options: window.available_industries
    }
    description: {
      type: "text"
    }
    region: {required: true}
    name: { required: true }
    position: {required: true}
    employees_count: {
      type: "integer"
      required: true
    }
  }, data) +

  column("medium-6", {
    company_site: {}
    offices: {
      type: "offices"
    }
    social_networks: { type: "social_networks" }
    #social_facebook: { type: "social", icon: "facebook" }
    #social_google_plus: { type: "social", icon: "google_plus" }


  }, data)


  add_title = t("add_company")
  remove_title = t("remove_company")
  save_title = t("save_company")
  if render_controls
    add_company_button_str = "<div class='btn company-button-add role-company-control-add' title='#{add_title}'><div class='btn-content'>#{svg_images.plus}<span class='btn-text'>#{add_title}</span></div></div>"
    save_company_control_str = "<div class='company-control company-control-save' title='#{save_title}'><div class='company-control-icon'>#{svg_images.check}</div><label class='company-control-label'>#{save_title}</label></div>"
    company_controls_str = "<div class='company-controls'><div class='company-self-controls'>#{save_company_control_str}<div class='company-control company-control-remove' title='#{remove_title}'><div class='company-control-icon'>#{svg_images.plus}</div><label class='company-control-label'>#{remove_title}</label></div></div><div class='company-controls-separator'></div><div class='new-company-controls'>#{add_company_button_str}</div></div>"
  else
    company_controls_str = ""
  "<div class='company'><div class='row'>#{form_str}</div>#{company_controls_str}</div>"

render_companies = (data)->
  s = ""


  if data && Array.isArray(data) && data.length
    for c in data
      s += render_company_form(c, true)
  else
    s = render_company_form({}, true)

  s


initialize_inputs = ()->
  inputs.date.initialize()
  inputs.phone.initialize()
  inputs.social.initialize()
  inputs.select_with_custom_value.initialize()

put_profile = ()->
  data = {user: form_to_json.call($("#cabinet-profile-form"))}
  $.ajax(
    data: data
    dataType: "json"
    url: "/cabinet/profile"
    type: "post"
  )

put_companies = ()->
  data = {companies: []}
  $("#cabinet-companies .company").each(
    ()->
      $company = $(this)
      json = form_to_json.call($company)
      data.companies.push(json)
  )

  $.ajax(
    data: data
    dataType: "json"
    url: "/cabinet/companies"
    type: "post"
  )

initialize_registration_forms = ()->
  return if is_cabinet
  if $("#registration-user").length
    $("#registration-user").html(registration_user_form)
  if $("#registration-company").length
    $("#registration-company").html(render_company_form())


  initialize_inputs()




initialize_cabinet = ()->
  if is_cabinet

    try
      user_data = JSON.parse($(".cabinet-container").attr("data-user"))
    catch
      user_data = undefined

    try
      companies_data = JSON.parse($(".cabinet-container").attr("data-companies"))
    catch
      companies_data = undefined

    $("#cabinet-profile-form").html(render_cabinet_user_form(user_data))

    #console.log "companies_data: ", companies_data
    companies_str = render_companies(companies_data)
    $("#cabinet-companies").html(companies_str)

    initialize_inputs()



window.set_input_presence_classes = ()->
  $input_wrap = $(this)
  value = $input_wrap.find("input, textarea").val()

  empty = !value || !value.length
  add_presence_class = if empty then "empty" else "not-empty"
  remove_presence_class = if empty then "not-empty" else "empty"
  #console.log "set_input_presence_classes: add_presence_class: ", add_presence_class, "remove_presence_class: ", remove_presence_class
  $input_wrap.changeClasses(add_presence_class, remove_presence_class)

validateEmail = (email)->
  re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);


validate_input__update_dom = (value, valid, add_presence_class, remove_presence_class)->
  #console.log "validate_input__update_dom: args: ", arguments
  #console.log "validate_input__update_dom: value: ", value, "; valid: ", valid, "; add_presence_class: ", add_presence_class
  $input_wrap = $(this)
  empty = !value || !value.length
  add_presence_class ?= ""
  add_presence_class += if empty then " empty" else " not-empty"
  remove_presence_class ?= ""
  remove_presence_class += if empty then " not-empty" else " empty"

  if valid == "ajax"
    add_presence_class += " ajax-validation-in-progress"
    remove_presence_class += " valid invalid invalid-email-exists"

  else
    remove_presence_class += " ajax-validation-in-progress"

    if valid == true
      add_presence_class += " valid"
      remove_presence_class += " invalid invalid-email-exists"

    else
      add_presence_class += " invalid"
      remove_presence_class += " valid"


  $input_wrap.changeClasses(add_presence_class, remove_presence_class)
  return

  ###
  if valid == true
    $input_wrap.changeClasses(["valid", add_presence_class], ["invalid", "invalid-email-exists", "ajax-validation-in-progress", remove_presence_class])
  else if valid == "ajax"
    $input_wrap.changeClasses(["ajax-validation-in-progress"], ["valid", add_presence_class, "invalid", remove_presence_class])

  else
    $input_wrap.changeClasses(["invalid", add_presence_class], ["valid", remove_presence_class])
  ###

append_email_exists_error_message = ()->
  $input_wrap = $(this)
  $error_message = $input_wrap.find(".email-exists-error-message")
  if !$error_message.length
    $input_wrap.append("<span class='email-exists-error-message'>Користувач з таким email'ом email вже існує</span>")

append_email_ajax_loader = ()->
  $input_wrap = $(this)
  $error_message = $input_wrap.find(".email-ajax-loader")
  if !$error_message.length
    $input_wrap.append("<span class='email-ajax-loader'>Перевіряю, чи email вільний...</span>")


window.validate_input = (update_dom = false)->
  $input_wrap = $(this)
  #alert($input_wrap.attr("data-key"))
  validation = $input_wrap.attr("validation")
  validation = validation && validation.length && JSON.parse(validation)

  if validation && keys(validation).length
    value = $input_wrap.find("select, input, textarea").val()
    value = "" if $input_wrap.hasClass("input-phone") && value.indexOf("_") >= 0
    valid = true
    present = value && value.length && true
    blank = !present
    if validation.required
      valid = value.length > 0

    if present

      if validation.min_length && value.length < validation.min_length
        valid = false

      if validation.max_length && value.length > validation.max_length
        valid = false



    if validation.must_equal
      another_field_value = $input_wrap.parent().find("[data-key='#{validation.must_equal}'] input").val()
      if value != another_field_value
        valid = false

    if validation.email
      if !validateEmail(value)
        valid = false



    if valid != false && validation.check_if_email_available
      if update_dom
        valid = check_if_email_available(value,
          (data)->
            current_input_value = $input_wrap.find("input, textarea").val()
            #console.log "validate_input: check_input: callback: value: ", value, "; current_input_value: ", current_input_value
            if current_input_value != value
              return
            local_valid = !data.exists
            #console.log "local_valid: ", local_valid
            add_presence_class = ""
            remove_presence_class = ""
            add_presence_class = "invalid-email-exists" if local_valid == false
            validate_input__update_dom.call($input_wrap, value, local_valid, add_presence_class, remove_presence_class)
            if local_valid == false
              append_email_exists_error_message.call($input_wrap)
        )

        if valid == "ajax"
          append_email_ajax_loader.call($input_wrap)
          validate_input__update_dom.call($input_wrap, value, valid)

        if valid != "ajax"
          add_presence_class = ""
          remove_presence_class = ""
          add_presence_class = "invalid-email-exists" if valid == false
          #console.log "validate_input: valid != ajax: valid: ", valid, "value: ", value
          validate_input__update_dom.call($input_wrap, value, valid, add_presence_class, remove_presence_class)

          if valid == false
            append_email_exists_error_message.call($input_wrap)
      else
        valid = check_if_email_available(value)


      return valid


    if !valid
      #console.log "invalid: clear email exists"
      validate_input__update_dom.call($input_wrap, value, valid, "", "invalid-email-exists")
    else
      validate_input__update_dom.call($input_wrap, value, valid)

    return valid
  else
    if update_dom
      set_input_presence_classes.call(this)
    return true





initialize_registration_forms()
initialize_cabinet()

init_forms = (e)->
  ###
  if e
    console.log "init registration forms: e.type: ", e.type
  else
    console.log "init forms"
  ###
  window.is_cabinet = check_if_cabinet()
  initialize_registration_forms()
  initialize_cabinet()

init_forms()
$document.on "page:load ready", init_forms

$document.on "keyup change", "#cabinet-profile-form", ()->
  delay("put_profile", put_profile, 1000)


$document.on "keyup change", "#cabinet-companies", (e)->
  $company = $(e.target).closest(".company")
  if !$company.hasClass("has-explicitly-unsaved-changes")
    $save_button = $company.find(".company-control-save")
    #$save_button.css({display: "inline-block"})
    $save_button.css({display: "inline-block"})
    setTimeout(
      ()->
        $company.addClass("has-explicitly-unsaved-changes")
      10
    )

    setTimeout(
      ()->
        $save_button.css({display: ""})
      500

    )

  delay("put_companies", put_companies, 1000)




$document.on "keyup change", "#cabinet-profile-form", (e)->
  $form = $(this)
  if !$form.hasClass("has-explicitly-unsaved-changes")
    $save_button = $form.find(".cabinet-profile-control-save")
    #$save_button.css({display: "inline-block"})
    $save_button.css({display: "inline-block"})
    setTimeout(
      ()->
        $form.addClass("has-explicitly-unsaved-changes")
      10
    )

    setTimeout(
      ()->
        $save_button.css({display: ""})
      500

    )

  delay("put_profile", put_profile, 1000)







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


window.form_to_json = ()->
  obj = {}
  except_keys = ["offices[]"]
  $form = $(this)
  $form.find(".input").map(
    ()->
      $input = $(this)

      k = $input.attr("data-key")
      if k == undefined
        return

      if except_keys.includes(k)
        return null
      for except_key in except_keys
        if k.startsWith(except_key + ".")
          return null

      val = $input.find("input, textarea, select").val()


      if k.endsWith("[]")
        k = k.substr(0, k.length - 2)
        obj[k] = [] if !obj[k]
        key_parts = k.split(".")
        target = obj[k]
        target.push(val)
      else
        obj[k] = val

  )

  offices = []
  $form.find(".office-inputs").map(
    ()->
      office = {}
      $office = $(this)
      office["city"] = $office.find(".input input[name='city']").val()
      office["address"] = $office.find(".input input[name='address']").val()
      office["phones"] = $office.find(".input input[name='phone']").map(
        ()->
          $(this).val()
      ).toArray()

      offices.push(office)
  )
  obj['offices'] = offices

  obj

window.steps_to_json = ()->
  {user: form_to_json.call($("#registration-user")), company: form_to_json.call($("#registration-company")) }

window.validate_inputs = (update_dom = false, handler)->

  all_valid = true
  $(this).each(
    ()->
      #console.log "validate"
      #alert("validate_inputs: #{$(this).attr('data-key')}")
      if all_valid != false || update_dom

        valid = validate_input.call(this, update_dom, handler)

        if valid != true && (all_valid == true || all_valid == "ajax")
          all_valid = valid

      else if valid == "ajax"
        all_valid = "ajax"
      #else
      #  return false

      true
  )

  all_valid

summary_field_types = {
  string: {
    render: (name, value, options = {})->
      if !value || !value.length
        return ""
      field_name = t("summary_labels.#{name}") || t("attributes.#{name}") || name
      field_value = value
      type = options.type || "string"

      "<div class='field #{type} field-#{name}'><div class='field-name'>#{field_name}</div><div class='field-value'>#{field_value}</div></div>"
  }

  phones: {
    render: (name, value, options = {})->
      options.type ?= "phones"
      str = value.join("<br/>")
      summary_field_types.string.render(name, str, options)
  }

  site: {
    render: (name, value, options = {})->
      options.type ?= "site"
      if !value || !value.length
        return ""
      field_name = t("attributes.#{name}") || name
      field_value = value
      formatted_value = "<a href='#{field_value}'>#{field_value}</a>"
      "<div class='field #{options.type} field-#{name}'><div class='field-name'>#{field_name}</div><div class='field-value'>#{formatted_value}</div></div>"
  }

  offices: {
    render: (name, value, options = {})->
      offices_collection = value
      offices_str = ""
      offices = offices_collection.map(
        (office)->
          phones_str = ""
          phones = office.phones.filter(
            (phone)->
              phone && phone.length > 0
          ).map(
            (phone)->
              "<span>#{phone}</span>"
          )
          if phones.length
            phones_str = phones.join(", ")


          "м. #{office.city}, #{office.address}#{if phones_str.length then '<br/>' + phones_str else '' }"
      ).filter(
        (office_str)->
          office_str.length > 0
      ).map(
        (office_str)->
          "<p>#{office_str}</p>"
      )

      offices_str = offices.join("")

      options.type ?= "offices"


      summary_field_types.string.render(name, offices_str, options)
  }
  social: {
    render: (name, value, options = {})->
      if !value || !value.length
        return ""
      options.type ?= "social"
      icon_str = svg_images[name]
      url = value
      social_str = "<a href='#{url}' class='social-icon popup-window-link' target='_blank'>#{icon_str}</a>"
      summary_field_types.string.render(name, social_str, options)
  }

}

window.render_summary = (data)->
  user_info = {
    first_name: {}
    middle_name: {}
    last_name: {}
    birth_date: {}
    phones: {}
    email: {}
  }

  company_info = {
    name: {}
    industry: {}
    description: {}
    region: {}
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



navigate_step = (direction)->
  $active_step_content = $(this)
  $step_headers = $(".step-headers")
  $active_step_header = $step_headers.children().filter(".active")
  $active_step_header.removeClass("active")
  $active_step_header[direction]().addClass("active")


  $active_step_content.removeClass("active")
  $active_step_content[direction]().addClass("active")

ajaxit = (iframe_id, form_id)->
  iFrameWindow = document.getElementById(iframe_id).contentWindow
  iFrameWindow.document.body.appendChild document.getElementById(form_id).cloneNode(true)
  frameForm = iFrameWindow.document.getElementById(form_id)
  frameForm.onsubmit = null
  frameForm.submit()
  false

$document.on "click", ".prev-step-button, .next-step-button", (e)->
  e.preventDefault()

  $step_contents = $(".step-contents")
  $active_step_content = $step_contents.children().filter(".active")

  $button = $(this)
  direction = if $button.hasClass("prev-step-button") then 'prev' else 'next'
  valid_step = true
  if direction == 'next'

    valid_step = validate_inputs.call($active_step_content.find(".input[validation]")
      (data)->
        if !data.exists
          navigate_step.call($active_step_content, direction)
      true)


    console.log "change_step: valid_step: ", valid_step

    if $active_step_content.index() == 1
      window.steps_json = steps_to_json()
      render_summary(steps_json)
  if valid_step != true
    return

  navigate_step.call($active_step_content, direction)




$document.on "click", ".step-navigation-button.send-form", ()->
  json = steps_to_json()
  $.ajax(

    type: "post"
    data: json
  )

  # alert("вам на пошту надіслано лист з підтвердженням")
  $('.success-popup-wrapper').fadeIn('200')





$document.on "keyup", "input[name=first_name], input[name=middle_name], input[name=last_name]", (e)->
  val = $(this).val()
  capitalized = val.capitalize()
  if capitalized != val
    $(this).val(capitalized)

    $(this).trigger("keyup", e)
    $(this).trigger("change")
  true

$document.on "keyup blur change", ".input", ()->
  $input = $(this)
  if $input.filter("[validation]").length
    validate_input.call($input, true)
  else
    set_input_presence_classes.call($input)


$document.on "change", ".input-select-with-custom-value select", ()->
  if is_cabinet
    put_companies()

$document.on "click", ".phones .inputs-collection-control", ()->
  $button = $(this)
  action = if $button.hasClass("inputs-collection-control-add") then 'add' else 'remove'
  $inputs_collection = $button.closest(".inputs-collection")
  $inputs_collection_inputs = $inputs_collection.find(".inputs-collection-inputs")
  $inputs_collection_inputs_children = $inputs_collection_inputs.children()

  if action == "add"
    input_str = inputs.phone.render("phone", {key: "phones[]"})
    $inputs_collection_inputs.append(input_str)
    inputs.phone.initialize()
  else
    $inputs_collection_inputs_children.last().remove()


  if $inputs_collection_inputs.children().length > 1
    $inputs_collection.removeClass("inputs-collection-single-input")
  else
    $inputs_collection.addClass("inputs-collection-single-input")

  put_profile() if is_cabinet







$document.on "change", "#user_photo", ()->
  $(".image-loading-in-progress").addClass("show")
  $(this).closest("form").ajaxSubmit({
    #target: 'myResultsDiv'
    success: (data)->
      #console.log "RESULT: ", arguments
      #window.location.reload()
      $cabinet_avatar = $(".cabinet-avatar")
      $cabinet_img_background = $cabinet_avatar.find(".img-background")
      if $cabinet_img_background.length
        $cabinet_img_background.css(
          "background-image", "url('#{data.cabinet_avatar_url}')"
        )
      else
        bg = "url(#{data.cabinet_avatar_url})"
        $cabinet_avatar.append("<div class='img-background' style='background-image: #{bg}'></div>")

      $cabinet_avatar.removeClass("no-photo")

      $(".login-field .user-icon, .menu-user-block .user-avatar").each(
        ()->
          $img = $(this).find("img")
          if $img.length
            $img.attr(
              "src", data.small_avatar_url
            )

          else
            $(this).append("<img src='#{data.small_avatar_url}' />")
            $(this).addClass("has-photo")
      )


      $(".image-loading-in-progress").removeClass("show")

  })

$document.on "click", ".company-control-add, .role-company-control-add", ()->
  $button = $(this)
  $company = $button.closest(".company")
  company_str = render_company_form({}, true)
  $new_company = $(company_str)
  $new_company.insertAfter($company)
  initialize_inputs()

$document.on "click", ".company-control-remove", ()->
  $button = $(this)
  $company = $button.closest(".company")



  show_remove_company_confirm_popup($company)



$document.on "click", ".office-control-save", ()->
  $button = $(this)
  return if $button.hasClass("disabled")

  $office = $button.closest(".input-office")
  office_index = $office.index()
  $company = $office.closest(".company")
  company_json = form_to_json.call($company)
  data = company_json.offices[office_index]
  #console.log "OFFICES: ", company_json.offices

  str = inputs.office.render_locked(data)
  $office_preview = $office.find(".office-preview")

  if $office_preview.length > 0
    $office_preview.html(str)
  else
    $office_preview = $("<div class='office-preview'>#{str}</div>")
    $office.prepend($office_preview)

  $office.addClass("preview-mode")


$document.on "click", ".office-control-remove", ()->
  $button = $(this)
  $office = $button.closest(".input-office")

  show_remove_office_confirm_popup($office)



$document.on "click", ".office-control-edit", ()->
  $(this).closest(".input-office").removeClass("preview-mode")

$document.on "click", ".office-control-add", ()->
  $office = $(this).closest(".input-office")
  new_office_str = inputs.office.render("office", {key: "offices[]"}, {})
  $new_office = $(new_office_str)
  $new_office.insertAfter($office)
  inputs.phone.initialize()


$document.on "click", ".remove-office-popup .btn-remove-office-ok", (e)->
  e.preventDefault()
  $wrap = $(this).closest(".popup-wrapper")
  company_index = $wrap.attr("data-company-index")
  office_index = $wrap.attr("data-office-index")
  $company = $(".company").eq(company_index)
  $offices_input = $company.find(".offices")
  $office_inpts_wrap = $offices_input.find(".inputs-collection-inputs")
  $office = $office_inpts_wrap.children().eq(office_index)
  $office.remove()
  put_companies() if is_cabinet


  if !$office_inpts_wrap.children().length
    new_office_str = inputs.office.render("office", {key: "offices[]"}, {})

    $office_inpts_wrap.append(new_office_str)

  close_popup.call($wrap)



$document.on "click", ".remove-company-popup .btn-remove-company-ok", (e)->
  e.preventDefault()
  $popup = $(this).closest(".remove-company-popup")
  removing_popup = $popup.data("data_removing_popup")

  if !removing_popup
    $popup.data("data_removing_popup", true)

    #console.log "remove popup"
    $popup.fadeOut('100')
    setTimeout(
      ()->
        $popup.data("data_removing_popup", false)
      500
    )

    i = $popup.attr("data-company-index")
    $company = $("#cabinet-companies .company").eq(i)
    $company.remove()
    put_companies()
  else
    return





$document.on "keyup",
  "#cabinet-profile-form [data-key=first_name], #cabinet-profile-form [data-key=last_name]",
  ()->
    $profile_form = $(this).closest("#cabinet-profile-form")
    first_name = $profile_form.find("[data-key=first_name] input").val()
    middle_name = $profile_form.find("[data-key=last_name] input").val()
    name = "#{first_name} #{middle_name}"
    $("#cabinet-person-name").text(name)



$document.on "keyup change", "#cabinet-companies .company input[name=name]", ()->
  $input = $(this)
  company_name = $input.val()
  company_name = t("placeholders.name") if !company_name || !company_name.length
  $company = $(this).closest(".company")
  $company.find(".company-name-column .company-name").text(company_name)


$document.on "keyup blur change", ".input-office input", ()->
  $office = $(this).closest(".input-office")
  city = $office.find("input[name=city]").val()
  address = $office.find("input[name=address]").val()
  phones = $office.find("input[name=phone]").map(
    ()->
      $(this).val()
  ).toArray().filter(
    (a)->
      a && a.length > 0 && a.indexOf("_") < 0
  )
  has_data = ((city && city.length) || (address && address.length) || (phones && phones.length && phones[0].length) ) && true

  $save_button = $office.find(".office-control-save")
  $save_button.removeClass("disabled") if has_data && $save_button.hasClass("disabled")
  $save_button.addClass("disabled") if !has_data && !$save_button.hasClass("disabled")



window.check_email = (email, handler, update_dom = false)->
  #console.log("1")
  email ?= $("#registration-user .input-email input").val()

  #console.log "check_email: ", email

  window.email_checks ?= []
  check_in_progress = window.email_checks.filter(
    (c)->
      c && c.in_progress && c.email == email
  )[0] || false

  email_check = window.email_checks.filter(
    (c)->
      c && c.email == email
  )[0] || false



  if check_in_progress
    return "ajax"

  if email_check
    return email_check.exists || false

  if email && email.length
    return if !validateEmail(email)

    window.email_checks.push({email: email, in_progress: true})

    $.ajax(
      url: "/check_email"
      dataType: "json"
      data: {email: email}
      success: (data)->

        h = window.email_checks.filter(
          (a)->
            a && a.email == data.email
        )[0]

        if !h
          return


        h.in_progress = false
        h.exists = data.exists


        #if !window.email_check
        #  window.email_check = data
        if handler && typeof(handler) == 'function'
          handler(data)

    )


  return "ajax"

window.check_if_email_available = ()->
  exists = check_email.apply(this, arguments)

  if exists != "ajax"
    return !exists
  else
    return "ajax"

update_dom_for_email_presence = (data)->
  $input_wrap = $("#registration-user .input-email")
  if data.exists
    $input_wrap.changeClasses(["invalid", "invalid-email-exists"], ["valid"])
    $error_message = $input_wrap.find(".email-exists-error-message")
    if !$error_message.length
      $input_wrap.append("<span class='email-exists-error-message'>Користувач з таким email'ом email вже існує</span>")
  else
    $input_wrap.changeClasses(["valid"], ["invalid", "invalid-email-exists"])


handle_save_button_click = ($button, $form)->
  $button.css({display: "inline-block"})
  if $form.hasClass("has-explicitly-unsaved-changes")
    $form.removeClass("has-explicitly-unsaved-changes")

  setTimeout(
    ()->
      $button.css({display: ""})
    500
  )

  $form_inputs = $form.find(".input[validation]")
  validate_inputs.call($form_inputs, true)

$document.on "click", ".company-control-save", ()->
  $button = $(this)
  $form = $button.closest(".company")
  handle_save_button_click($button, $form)

$document.on "click", ".cabinet-profile-control-save", ()->
  $button = $(this)
  $form = $button.closest("#cabinet-profile-form")
  handle_save_button_click($button, $form)









