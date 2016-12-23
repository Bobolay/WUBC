locales = {
  uk: {
    add_office: "Додати ще офіс"
    save_office: "Зберегти"
    add_phone: "Додати ще телефон"
    remove_phone: "Видалити телефон"
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

    }
    placeholders: {
      first_name: "Петро"
      middle_name: "Петрович"
      last_name: "Петренко"
      birth_date: "01.12.1991"
      email: "user@server.com"
      password: "12345678"
      password_confirmation: "12345678"

      name: "Назва компанії"
      industry: "Розваги"
      region: "Львів"
      position: "директор"
      employees_count: "24"
      company_site: "site.com"

      city: "Львів"
      address: "вул. Наукова, 21"
      hobby: "Читаю книжки, слухаю музику, ходжу в театр"

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

    input: (name, options)->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='text' placeholder='#{placeholder}' class='#{options.class}' />"

    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      key = options.key || name
      input_str = inputs.string.input(name, options)
      "<div #{wrap_attributes} class='input register-input' data-key='#{key}'>#{label}#{input_str}</div>"

  }

  social: {

    input: (name, options)->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='text' placeholder='#{placeholder}' class='#{options.class}' />"

    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.string.input(name, options)
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
    input: (name, options)->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='email' placeholder='#{placeholder}' class='#{options.class}' />"

    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.email.input(name, options)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}</div>"

  }

  password: {
    input: (name, options)->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='password' placeholder='#{placeholder}' class='#{options.class}' />"
    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.password.input(name, options)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}</div>"
  }

  text: {
    input: (name, options)->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<textarea name='#{html_name}' placeholder='#{placeholder}' class='#{options.class}' ></textarea>"
    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.text.input(name, options)
      textarea_corner = "<div class='textarea-corner'></div>"
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}#{textarea_corner}</div>"
  }

  integer: {
    input: (name, options)->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='number' placeholder='#{placeholder}' class='#{options.class}' />"

    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.integer.input(name, options)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}</div>"
  }
  date: {
    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      options = $.extend({class: "datepicker"}, options)
      icon_source = svg_images.calendar
      label = inputs.base.label(name, options)
      input_str = inputs.string.input(name, options)
      icon_label = "<label class='icon icon-calendar'>#{icon_source}</label>"
      "<div #{wrap_attributes} class='input register-input input-date'>#{label}#{input_str}#{icon_label}</div>"


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

      })

      $("")
  }

  inputs_collection: {
    inputs_collection_controls: ()->
      add_title = t("add_phone")
      remove_title = t("remove_phone")
      "<div class='inputs-collection-controls'><div class='inputs-collection-control inputs-collection-control-add' title='#{add_title}'>#{svg_images.plus}</div><div class='inputs-collection-control inputs-collection-control-remove' title='#{remove_title}'>#{svg_images.plus}</div></div>"

  }

  phones: {
    render: (name, options)->
      options = $.extend({label: false}, options)

      phone_inputs_str = ""
      label = inputs.base.label(name, options)
      phone_options = options.phone_options || {}
      phone_options.required = true if options.min && options.min >= 1
      key = options.key || name
      phone_options = $.extend({key: "#{key}[]"}, phone_options)

      phone_inputs_str += inputs.phone.render("phone", phone_options)
      phone_inputs_str = "<div class='inputs-collection-inputs'>#{phone_inputs_str}</div>"
      inputs_collection_controls = inputs.inputs_collection.inputs_collection_controls()

      "<div class='inputs-collection phones inputs-collection-single-input'>#{label}#{phone_inputs_str}#{inputs_collection_controls}</div>"
  }

  phone: {
    input: (name, options)->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input name='#{html_name}' type='tel' placeholder='#{placeholder}' class='#{options.class}' />"

    render: (name, options)->
      console.log "phone: options: ", options
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      key = options.key || name
      label = inputs.base.label(name, options)
      input_str = inputs.phone.input(name, options)
      "<div #{wrap_attributes} class='input register-input input-phone' data-key='#{key}'>#{label}#{input_str}</div>"

    initialize: ()->
      $inputs = $(".input-phone:not(.mask-initialized)")
      $inputs.find("input").mask("+99 (999) 999 99 99")
      $inputs.addClass("mask-initialized")

  }

  offices: {
    render: (name, options)->
      office_inputs_str = ""
      label = inputs.base.label(name, options)
      office_options = options.office_options || {}
      key = options.key || name
      office_options.key = "#{key}[]"
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

    render: (name, options)->
      options = $.extend({label: false}, options)
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.email.input(name, options)
      key = options.key || name
      office_inputs_str = ""
      office_inputs_str += inputs.string.render("city", {key: "#{key}.city"})
      office_inputs_str += inputs.string.render("address", {key: "#{key}.address"})
      office_inputs_str += inputs.phones.render("phones", {key: "#{key}.phones"})
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
render_inputs_to_string = (props)->
  res = ""
  for k, v of props
    type = v.type || "string"
    types_by_column_name = {password: "password", password_confirmation: "password", email: "email", phones: "phones"}
    type_by_column_name = types_by_column_name[k]
    type = type_by_column_name if !v.type && type_by_column_name
    console.log "type: ", type
    res += inputs[type].render(k, v)

  res

column = (html_class, props)->
  s = render_inputs_to_string(props)
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

window.cabinet_user_form = column("medium-6", {
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



window.company_form = column("medium-12"
  name: {
    required: true
    class: "material-input"
    label: false
  }
) +
column("medium-6", {
  industry: {
    required: true
  }
  description: {
    type: "text"
  }
  region: {required: true}
  position: {required: true}
  employees_count: {
    type: "integer"
    required: true
  }
}) +
column("medium-6", {
  company_site: {}
  offices: {
    type: "offices"
  }
  #social_networks: {}
  social_twitter: { type: "social", icon: "facebook" }
  social_google_plus: { type: "social", icon: "google_plus" }
  social_facebook: { type: "social", icon: "facebook" }
  social_linkedin: { type: "social", icon: "facebook" }
  social_vk: { type: "social", icon: "facebook" }
})

$("#registration-user").html(registration_user_form)
$("#registration-company").html(company_form)

$("#cabinet-profile-form").html(cabinet_user_form)



initialize_inputs = ()->
  inputs.date.initialize()
  inputs.phone.initialize()


initialize_profile = ()->

initialize_cabinet = ()->
  initialize_profile()


initialize_inputs()
initialize_cabinet()






window.form_to_json = ()->
  obj = {}
  $(this).find(".input").map(
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

      val = $input.find("input, textarea").val()

      if k.endsWith("[]")
        k = k.substr(0, k.length - 2)
        obj[k] = [] if !obj[k]
        target = obj[k]
        target.push(val)
      else
        obj[k] = val

  )

  obj

window.steps_to_json = ()->
  {user: form_to_json.call($("#registration-user")), company: form_to_json.call($("#registration-company")) }

validate_inputs = (update_dom = false)->
  return true
  valid = true
  all_valid = true
  $(this).each(
    ()->
      alert("validate_inputs: #{$(this).attr('data-key')}")
      if valid || update_dom

        valid = validate_input.call(this, update_dom)

        if !valid
          all_valid = false
      #else
      #  return false
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


$document.on "click", ".step-navigation-button.send-form", ()->
  json = steps_to_json()
  $.ajax(

    type: "post"
    data: json
  )

  # alert("вам на пошту надіслано лист з підтвердженням")
  $('.success-popup-wrapper').fadeIn('200')


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



