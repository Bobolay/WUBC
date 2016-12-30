is_cabinet = $("body").hasClass("cabinet__index")
locales = {
  uk: {
    add_office: "Додати ще офіс"
    save_office: "Зберегти"
    add_phone: "Додати ще телефон"
    remove_phone: "Видалити телефон"
    add_company: "Додати нову компанію"
    remove_company: "Видалити компанію"
    attributes: {
      premium: "Тільки для членів клубу"
      first_name: "Ім'я"
      last_name: "Прізвище"
      middle_name: "По батькові"
      birth_date: "Дата народження"
      phone: "Телефон"
      email: "Логін e-maill"
      password: "Пароль"
      password_confirmation: "Підтвердження паролю"
      phones: "Телефони"

      industry: "Сфера здійснення діяльності"
      region: "Місце здійснення діяльності"
      position: "Посада"
      employees_count: "Кількість працівників"
      company_site: "Сайт компанії"
      offices: "Контакти офісів"
      social_networks: "Соц. мережі компанії"
      description: "Опис діяльності"

      city: "Місто"
      address: "Адреса"
      hobby: "Хоббі"
      name: "Назва компанії"

    }
    placeholders: {
      first_name: "Петро"
      middle_name: "Петрович"
      last_name: "Петренко"
      birth_date: "01.12.1991"
      email: "user@server.com"
      password: "Пароль"
      password_confirmation: "Повторіть пароль"

      description: "Напишіть щось про свою компанію"
      industry: "Розваги"
      region: "Львів"
      position: "директор"
      employees_count: "24"
      company_site: "site.com"

      city: "Львів"
      address: "вул. Наукова, 21"
      hobby: "Читаю книжки, слухаю музику, ходжу в театр"
      name: "Моя компанія"
      phone: "Телефон"

    }
  }
}

current_locale = "uk"
window.t = (key)->
  translation = locales[current_locale]
  key_parts = key.split(".")
  i = 0
  for key_part in key_parts
    #console.log "key_part: ", key_part
    translation = translation[key_part]
    if translation == undefined || translation == null
      return null
    else if i == key_parts - 1
      return translation
    i++

  translation

window.inputs = {
  base: {
    html_name: (name, options)->
      options.name || name
    label: (name, options)->
      if options.label == false
        return ""
      if options.label
        s = options.label
      else
        s = t("attributes.#{name}") || name
      required_mark_str = if options.required then "<span class='required-mark'>*</span>" else ""
      "<label class='input-label'>#{s}: #{required_mark_str}</label>"
    placeholder: (name)->
      t("placeholders.#{name}") || name
    wrap_attributes: (name, options)->
      validation_attributes = ["required", "must_equal"]
      validation = {}
      options = {} if !options
      for k, v of options
        if validation_attributes.includes(k)
          validation[k] = v

      res = {validation: validation}
      s = ""
      for k, v of res
        s+= "#{k}='#{JSON.stringify(v)}'"

      s

  }
  string: {

    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='text' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      key = options.key || name
      input_str = inputs.string.input(name, options, data)
      "<div #{wrap_attributes} class='input register-input' data-key='#{key}'>#{label}#{input_str}</div>"

  }

  social: {

    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='text' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.string.input(name, options, data)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}</div>"

  }

  social_networks: {
    render: (name, options)->
      options = $.extend({label: false}, options)
      phone_inputs_str = ""
      label = inputs.base.label(name, options)
      phone_options = options.phone_options || {}

      phone_inputs_str += inputs.phone.render("phone", phone_options)
      phone_inputs_str = "<div class='inputs-collection-inputs'>#{phone_inputs_str}</div>"
      inputs_collection_controls = inputs.inputs_collection.inputs_collection_controls()
      "<div class='inputs-collection phones inputs-collection-single-input'>#{label}#{phone_inputs_str}#{inputs_collection_controls}</div>"
  }

  email: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='email' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data = '')->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.email.input(name, options, data)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}</div>"

  }

  password: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='password' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"
    render: (name, options, data = '')->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.password.input(name, options, data)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}</div>"
  }

  text: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      options.class ?= ""
      "<textarea name='#{html_name}' placeholder='#{placeholder}' class='#{options.class}'>#{data}</textarea>"
    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options, data)
      label = inputs.base.label(name, options)
      input_str = inputs.text.input(name, options, data)
      textarea_corner = "<div class='textarea-corner'></div>"
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}#{textarea_corner}</div>"
  }

  integer: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='number' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.integer.input(name, options, data)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}</div>"
  }
  date: {
    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      options = $.extend({class: "datepicker"}, options)
      icon_source = svg_images.calendar
      label = inputs.base.label(name, options)
      input_str = inputs.string.input(name, options, data)
      icon_label = "<label class='icon icon-calendar'>#{icon_source}</label>"
      key = options.key || name
      "<div #{wrap_attributes} class='input register-input input-date' data-key='#{key}'>#{label}#{input_str}#{icon_label}</div>"


    initialize: ()->
      $(".datepicker").datepicker({
        dateFormat: "dd.mm.yy",
        monthNames: [ "Січень", "Лютий", "Березень", "Квітень", "Травень", "Червень", "Липень", "Серпень", "Вересень", "Жовтень", "Листопад", "Грудень" ],
        dayNames: [ "Понеділок", "Вівторок", "Середа", "Четвер", "П'ятниця", "Субота", "Неділя" ],
        dayNamesMin: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Нд" ],
        dayNamesShort: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Нд" ],
        prevText: 'Попередній',
        nextText: 'Наступний',
        changeMonth: true,
        changeYear: true,
        yearRange: '1930:2010',
        onSelect: ()->
          $input_wrap = $(this).closest(".input")
          $input_wrap.addClass("not-empty")
          if is_cabinet
            put_profile()

      })


  }

  inputs_collection: {
    inputs_collection_controls: ()->
      add_title = t("add_phone")
      remove_title = t("remove_phone")
      "<div class='inputs-collection-controls'><div class='inputs-collection-control inputs-collection-control-add' title='#{add_title}'>#{svg_images.plus}</div><div class='inputs-collection-control inputs-collection-control-remove' title='#{remove_title}'>#{svg_images.plus}</div></div>"

  }

  phones: {
    render: (name, options, data)->
      options = $.extend({label: false}, options)

      phone_inputs_str = ""
      label = inputs.base.label(name, options)
      phone_options = options.phone_options || {}
      phone_options.required = true if options.min && options.min >= 1
      key = options.key || name
      phone_options = $.extend({key: "#{key}[]"}, phone_options)

      phones_count = (data && Array.isArray(data) && data.length ) || 0


      if phones_count
        for phone in data
          phone_inputs_str += inputs.phone.render("phone", phone_options, phone)
      else
        phone_inputs_str += inputs.phone.render("phone", phone_options)
      phone_inputs_str = "<div class='inputs-collection-inputs'>#{phone_inputs_str}</div>"
      inputs_collection_controls = inputs.inputs_collection.inputs_collection_controls()

      html_class = "inputs-collection phones"
      html_class += " inputs-collection-single-input" if !phones_count || phones_count == 0 || phones_count == 1
      "<div class='#{html_class}'>#{label}#{phone_inputs_str}#{inputs_collection_controls}</div>"
  }

  phone: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='tel' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data)->
      console.log "phone: options: ", options
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      key = options.key || name
      label = inputs.base.label(name, options)
      input_str = inputs.phone.input(name, options, data)
      "<div #{wrap_attributes} class='input register-input input-phone' data-key='#{key}'>#{label}#{input_str}</div>"

    initialize: ()->
      $inputs = $(".input-phone:not(.mask-initialized)")
      $inputs.find("input").mask("+99 (999) 999 99 99")
      $inputs.addClass("mask-initialized")

  }

  offices: {
    render: (name, options, data)->
      #console.log "offices: data: ", data
      office_inputs_str = ""
      label = inputs.base.label(name, options)
      office_options = options.office_options || {}
      key = options.key || name
      office_options.key = "#{key}[]"
      if data && data.length
        for office_data in data
          office_inputs_str += inputs.office.render("office", office_options, office_data)
      else
        office_inputs_str += inputs.office.render("office", office_options)
      office_inputs_str = "<div class='inputs-collection-inputs'>#{office_inputs_str}</div>"
      #inputs_collection_controls = "<div class='inputs-collection-controls'><div class='inputs-collection-control inputs-collection-control-add'>#{svg_images.plus}</div><div class='inputs-collection-control inputs-collection-control-remove'>#{svg_images.plus}</div></div>"
      inputs_collection_controls = ""
      "<div class='inputs-collection offices inputs-collection-single-input' data-key='#{key}'>#{label}#{office_inputs_str}#{inputs_collection_controls}</div>"
  }

  office: {
    input: (name, options)->
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input type='tel' placeholder='#{placeholder}' class='#{options.class}' />"

    render: (name, options, data)->
      console.log "OFFICE: data: ", data
      data ?= {}
      options = $.extend({label: false}, options)
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.email.input(name, options)
      key = options.key || name
      office_inputs_str = ""

      office_inputs_str += inputs.string.render("city", {key: "#{key}.city"}, data.city)
      office_inputs_str += inputs.string.render("address", {key: "#{key}.address"}, data.address)
      office_inputs_str += inputs.phones.render("phones", {key: "#{key}.phones"}, data.phones)
      office_inputs_wrap = "<div class='office-inputs'>#{office_inputs_str}</div>"
      office_controls_str = "<div class='office-controls'><div class='office-control office-control-add'>#{t("add_office")}</div><div class='office-control office-control-save'>#{t("save_office")}</div><div class='office-control office-control-edit'>#{svg_images.edit}</div><div class='office-control office-control-remove'>#{svg_images.plus}</div></div>"
      "<div #{wrap_attributes} class='input register-input input-office' data-key='#{key}'>#{label}#{office_inputs_wrap}#{office_controls_str}</div>"


    render_locked: (obj)->
      city_str = "<p><span>#{t('city')}:</span>#{obj.city}</p>"
      address_str = "<p><span>#{t('address')}:</span>#{obj.address}</p>"
      phones_str = "<p><span>#{t('address')}:</span>#{obj.phones.join("<br/>")}</p>"
      "<div class='filled-info'>#{city_str}#{address_str}#{phones_str}</div>"

  }
}
render_inputs_to_string = (props, data = {})->
  res = ""
  for k, v of props
    type = v.type || "string"
    types_by_column_name = {password: "password", password_confirmation: "password", email: "email", phones: "phones"}
    type_by_column_name = types_by_column_name[k]
    type = type_by_column_name if !v.type && type_by_column_name
    console.log "type: ", type
    prop_data = data[k]
    res += inputs[type].render(k, v, prop_data)

  res

column = (html_class, props, data)->
  s = render_inputs_to_string(props, data)
  "<div class='columns #{html_class}'>#{s}</div>"

window.registration_user_form = column("medium-6", {
  first_name: {required: true}
  middle_name: {required: true}
  last_name: {required: true},
  birth_date: {
    required: true
    type: "date"
  }
}) +
column( "medium-6", {
  phones: { required: true, min: 1 }
  email: {
    required: true
  }
  password: {
    required: true
  }
  password_confirmation: {
    required: true
    must_equal: "password"
  }
})






render_cabinet_user_form = (data)->
  column("medium-6", {
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
      required: true
    }
    password: {
    }
    password_confirmation: {
      must_equal: "password"
    }
    social_facebook: {}
    social_google_plus: {}
  }, data)


render_company_name_block = (company_name)->
  company_name = t("placeholders.name") if !company_name || !company_name.length
  "<div class='columns company-name-column'><div class='company-name'>#{company_name}</div></div>"

render_company_form = (data, render_controls = false)->
  data ?= {}
  company_name_str = render_company_name_block(data.name)
  form_str = company_name_str +
  column("medium-6", {
    industry: {
      required: true
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
    #social_networks: {}
    social_facebook: { type: "social", icon: "facebook" }
    social_google_plus: { type: "social", icon: "google_plus" }


  }, data)


  add_title = t("add_company")
  remove_title = t("remove_company")
  if render_controls
    company_controls_str = "<div class='company-controls'><div class='company-control company-control-add' title='#{add_title}'><div class='company-control-icon'>#{svg_images.plus}</div><label class='company-control-label'>#{add_title}</label></label></div><div class='company-control company-control-remove' title='#{remove_title}'><div class='company-control-icon'>#{svg_images.plus}</div><label class='company-control-label'>#{remove_title}</label></div></div>"
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
  if $("#registration-user").length
    $("#registration-user").html(registration_user_form)
  if $("#registration-company").length
    $("#registration-company").html(render_company_form())




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

initialize_registration_forms()
initialize_cabinet()

$document.on "keyup change", "#cabinet-profile-form", ()->
  delay("put_profile", put_profile, 1000)


$document.on "keyup change", "#cabinet-companies", ()->
  delay("put_companies", put_companies, 1000)




initialize_inputs()
initialize_cabinet()




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
      ###
      $parent_inputs_collection = $input.closest(".inputs-collection")
      if $parent_inputs_collection.length > 0
        if $parent_inputs_collection.hasClass("phones")
          val = $parent_inputs_collection.find(".input-phone input").map(
            ()->
              $(this).val()
          ).toArray()

        return
      ###

      k = $input.attr("data-key")
      if k == undefined
        return

      if except_keys.includes(k)
        return null
      for except_key in except_keys
        if k.startsWith(except_key + ".")
          return null



      val = $input.find("input, textarea").val()


#      k = k.split("[]").map(
#        (s, i, w)->
#          #console.log "map: this: ", this, "; args: ", arguments
#          is_array = s.endsWith("[]")
#          res = ""
#          if s.startsWith(".")
#            if !s.startsWith("[") && !s.endsWith("]")
#              res = "[#{s.substr(1, s.length)}]"
#            else
#              res = s.substr(1, s.length)
#          else if s == "[]"
#            res = ""
#          else if !(s.startsWith("[") || s.startsWith(".[") ) && !s.endsWith("]")
#            res = "[#{s.substr(0, s.length)}]"
#            res = s
#          else
#            res = s
#
#          res = "#{res}[]" if is_array
#
#          s
#      ).join("[]")

      #k = k.substr(0, k.length - 2) if k.endsWith("[][]")


      console.log "k: ", k

      if k.endsWith("[]")
        k = k.substr(0, k.length - 2)
        obj[k] = [] if !obj[k]
        key_parts = k.split(".")
        #set_value_to_object_key(obj, k, val)
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

validate_inputs = (update_dom = false)->

  valid = true
  all_valid = true
  $(this).each(
    ()->
      console.log "validate"
      #alert("validate_inputs: #{$(this).attr('data-key')}")
      if valid || update_dom

        valid = validate_input.call(this, update_dom)

        if !valid
          all_valid = false
      #else
      #  return false

      true
  )

  all_valid


validate_input = (update_dom = false)->
  $input_wrap = $(this)
  #alert($input_wrap.attr("data-key"))
  validation = $input_wrap.attr("validation")
  validation = validation && validation.length && JSON.parse(validation)



  if validation && keys(validation).length

    value = $input_wrap.find("input, textarea").val()
    valid = true
    if validation.required
      valid = value.length > 0



    if update_dom
      empty = !value || !value.length
      add_presence_class = if empty then "empty" else "not-empty"
      remove_presence_class = if empty then "not-empty" else "empty"
      if valid
        $input_wrap.changeClasses(["valid", add_presence_class], ["invalid", remove_presence_class])
      else
        $input_wrap.changeClasses(["invalid", add_presence_class], ["valid", remove_presence_class])
    return valid
  else
    return true


summary_field_types = {
  string: {
    render: (name, value)->
      if !value || !value.length
        return ""
      field_name = t("attributes.#{name}") || name
      field_value = value
      "<div class='field'><div class='field-name'>#{field_name}</div><div class='field-value'>#{field_value}</div></div>"
  }

  phones: {
    render: (name, value)->
      str = value.join("<br/>")
      summary_field_types.string.render(name, str)
  }
}

render_summary = (data)->
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
    company_site: {}
    offices: {}
    social_networks: {}
  }

  user_info_str = ""
  company_info_str = ""
  for k, field_definition of user_info
    v = data.user[k]
    type = "string"
    type = k if summary_field_types[k] && summary_field_types[k].render
    user_info_str += summary_field_types[type].render(k, v)

  for k, field_definition of company_info
    v = data.company[k]
    company_info_str += summary_field_types.string.render(k, v)

  s = "<div class='columns large-6'><div class='summary-header'>Основна інформація</div>#{user_info_str}</div><div class='columns large-6'><div class='summary-header'>Інформація про компанію</div>#{company_info_str}</div>"

  $("#registration-summary").html(s)





$document.on "click", ".prev-step-button, .next-step-button", (e)->
  e.preventDefault()

  $step_contents = $(".step-contents")
  $active_step_content = $step_contents.children().filter(".active")

  $button = $(this)
  direction = if $button.hasClass("prev-step-button") then 'prev' else 'next'
  valid_step = true
  if direction == 'next'
    valid_step = validate_inputs.call($active_step_content.find(".input[validation]"), true)
    if $active_step_content.index() == 1
      window.steps_json = steps_to_json()
      render_summary(steps_json)
  if !valid_step
    return
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

$document.on "keyup", ".input[validation]", ()->
  validate_input.call(this, true)

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




$document.on "click", ".office-control-save", ()->
  $office = $(this).closest(".input-office")
  office_index = $office.index()
  window.steps_json = steps_to_json()
  data = steps_json.company.offices[office_index]

  str = inputs.office.render_locked(data)
  $office_preview = $office.find(".office-preview")

  if $office_preview.length > 0
    $office_preview.html(str)
  else
    $office_preview = $("<div class='office-preview'>#{str}</div>")
    $office.prepend($office_preview)



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

$document.on "click", ".company-control-add", ()->
  $button = $(this)
  $company = $button.closest(".company")
  company_str = render_company_form({}, true)
  $new_company = $(company_str)
  $new_company.insertAfter($company)

$document.on "click", ".company-control-remove", ()->
  $button = $(this)
  $company = $button.closest(".company")
  $company.remove()
  put_companies()


$document.on "keyup",
  "#cabinet-profile-form [data-key=first_name], #cabinet-profile-form [data-key=last_name]",
  ()->
    $profile_form = $(this).closest("#cabinet-profile-form")
    first_name = $profile_form.find("[data-key=first_name] input").val()
    middle_name = $profile_form.find("[data-key=last_name] input").val()
    name = "#{first_name} #{middle_name}"
    $("#cabinet-person-name").text(name)


$document.on "blur", ".input input", ()->
  $input = $(this).closest(".input")
  validate_input.call($input, true)

$document.on "keyup change", "#cabinet-companies .company input[name=name]", ()->
  $input = $(this)
  company_name = $input.val()
  company_name = t("placeholders.name") if !company_name || !company_name.length
  $company = $(this).closest(".company")
  $company.find(".company-name-column .company-name").text(company_name)