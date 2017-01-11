is_cabinet = $("body").hasClass("cabinet__index")
locales = {
  uk: {
    add_office: "Додати ще офіс"
    save_office: "Зберегти"
    remove_office: "Видалити"
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
      new_password: "Новий пароль"
      password_confirmation: "Підтвердження паролю"
      phones: "Телефони"

      industry: "Сфера здійснення діяльності"
      region: "Місце здійснення діяльності"
      position: "Посада"
      employees_count: "Кількість працівників"
      company_site: "Сайт компанії"
      offices: "Контакти офісів"
      social_networks: "Соц. мережі компанії"
      user_social_networks: "Особисті соц. мережі"
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

      social_facebook: "https://www.facebook.com/YOUR_ACCOUNT"
      social_google_plus: "https://plus.google.com/YOUR_ACCOUNT"

    }
    summary_labels: {
      social_facebook: "Сторінка Facebook"
      social_google_plus: "Сторінка Google+"
    }
    help: {
      password: "Мінімум 8 символів"

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
    help: (name, options)->
      help = options.help || t("help.#{name}")
      help_str = if help && help.length then "<label class='help'>#{help}</label>" else ""

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
      validation_attributes = ["required", "must_equal", "email", "min_length", "max_length", "check_if_email_available"]
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

    autocomplete: (name, options = {})->
      k = options.autocomplete
      if k
        return "autocomplete='#{k}'"
      else
        return ""


    readonly: (name, options)->
      readonly = options.readonly || options.disabled
      if readonly
        return "disabled='disabled'"
      else
        return ""
  }
  string: {

    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      autocomplete_str = inputs.base.autocomplete(name, options)
      readonly_str = inputs.base.readonly(name, options)
      "<input #{readonly_str} #{autocomplete_str} name='#{html_name}' type='text' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      key = options.key || name
      input_str = inputs.string.input(name, options, data)
      help = inputs.base.help(name, options)
      "<div #{wrap_attributes} class='input register-input' data-key='#{key}'>#{label}#{input_str}#{help}</div>"

  }

  select_with_custom_value: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      autocomplete_str = inputs.base.autocomplete(name, options)
      readonly_str = inputs.base.readonly(name, options)
      options.class ?= ""
      options.class = "#{options.class} input-select-with-custom-value"
      "<input #{readonly_str} #{autocomplete_str} name='#{html_name}' type='text' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"
      options_html = ""
      options.select_options ?= []
      for opt in options.select_options
        selected_str = ""
        selected_str = "selected='selected'" if opt == data
        options_html += "<option value='#{opt}'>#{opt}</option>"

      "<select #{readonly_str} name='#{html_name}' data-placeholder='#{placeholder}' class='#{options.class}' #{selected_str}>#{options_html}</select>"

    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      key = options.key || name
      input_str = inputs.select_with_custom_value.input(name, options, data)
      help = inputs.base.help(name, options)
      "<div #{wrap_attributes} class='input register-input input-select-with-custom-value' data-key='#{key}'>#{label}#{input_str}#{help}</div>"

    initialize: ()->
      $(".input-select-with-custom-value:not(.select-initialized)").each(
        ()->
          $(this).addClass("select-initialized")
          $(this).find("select").selectize({
            sortField: 'text'
            createOnBlur: true
            create: true

          })
      )
  }

  social: {

    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      autocomplete_str = inputs.base.autocomplete(name, options)
      "<input #{autocomplete_str} name='#{html_name}' type='text' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.string.input(name, options, data)
      help = inputs.base.help(name, options)
      icon_str = "<div class='input-social-icon'>#{svg_images[options.icon]}</div>"
      "<div #{wrap_attributes} class='input register-input input-social' data-key='#{name}'>#{label}#{input_str}#{icon_str}#{help}</div>"

    initialize: ()->
      $(".input-social").filter(
        ()->
          !$(this).hasClass("empty") && !$(this).hasClass("not-empty")
      ).each(set_input_presence_classes)
  }

  social_networks: {
    render: (name, options, data = {})->
      #options = $.extend({label: false}, options)
      social_inputs_str = ""
      label = inputs.base.label(name, options)
      social_options = $.extend({label: false}, options.social_options)

      social_facebook_options = $.extend({}, social_options, {icon: "social_facebook"}, social_options.facebook)
      social_google_plus_options = $.extend({}, social_options, {icon: "social_google_plus"}, social_options.facebook)


      #social_facebook: { type: "social", icon: "facebook" }
      #social_google_plus: { type: "social", icon: "google_plus" }

      social_inputs_str += inputs.social.render("social_facebook", social_facebook_options, data.facebook)
      social_inputs_str += inputs.social.render("social_google_plus", social_google_plus_options, data.google_plus)
      social_inputs_wrap_str = "<div class='inputs-collection-inputs'>#{social_inputs_str}</div>"
      #inputs_collection_controls = inputs.inputs_collection.inputs_collection_controls()
      inputs_collection_controls = ""
      help = inputs.base.help(name, options)
      "<div class='inputs-collection social-networks inputs-collection-single-input'>#{label}#{social_inputs_wrap_str}#{inputs_collection_controls}#{help}</div>"
  }

  email: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      autocomplete_str = inputs.base.autocomplete(name, options)
      readonly_str = inputs.base.readonly(name, options)
      "<input #{readonly_str} #{autocomplete_str} name='#{html_name}' type='email' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data = '')->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.email.input(name, options, data)
      help = inputs.base.help(name, options)
      "<div #{wrap_attributes} class='input register-input input-email' data-key='#{name}'>#{label}#{input_str}#{help}</div>"

  }

  password: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      autocomplete_str = inputs.base.autocomplete(name, options)
      "<input #{autocomplete_str} name='#{html_name}' type='password' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"
    render: (name, options, data = '')->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.password.input(name, options, data)
      help = inputs.base.help(name, options)

      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}#{help}</div>"
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
      help = inputs.base.help(name, options)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}#{textarea_corner}#{help}</div>"
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
      help = inputs.base.help(name, options)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}#{help}</div>"
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
      help = inputs.base.help(name, options)
      "<div #{wrap_attributes} class='input register-input input-date' data-key='#{key}'>#{label}#{input_str}#{icon_label}#{help}</div>"


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
        minDate: "01.01.1930"
        maxDate: "31.12.2010"
        defaultDate: "01.01.1991"
        onSelect: ()->
          $input_wrap = $(this).closest(".input")
          #$input_wrap.changeClasses(["not-empty"], ["empty"])
          validate_input.call($input_wrap, true)
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
      help = inputs.base.help(name, options)
      "<div class='#{html_class}'>#{label}#{phone_inputs_str}#{inputs_collection_controls}#{help}</div>"
  }

  phone: {
    input: (name, options, data = '')->
      html_name = inputs.base.html_name(name, options)
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      autocomplete_options = $.extend({autocomplete: "tel"}, options)
      autocomplete_str = inputs.base.autocomplete(name, autocomplete_options)
      "<input #{autocomplete_str} name='#{html_name}' type='tel' placeholder='#{placeholder}' class='#{options.class}' value='#{data}' />"

    render: (name, options, data)->
      #console.log "phone: options: ", options
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      key = options.key || name
      label = inputs.base.label(name, options)
      input_str = inputs.phone.input(name, options, data)
      help = inputs.base.help(name, options)
      "<div #{wrap_attributes} class='input register-input input-phone' data-key='#{key}'>#{label}#{input_str}#{help}</div>"

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
      help = inputs.base.help(name, options)
      "<div class='inputs-collection offices inputs-collection-single-input' data-key='#{key}'>#{label}#{office_inputs_str}#{inputs_collection_controls}#{help}</div>"
  }

  office: {
    input: (name, options)->
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input type='tel' placeholder='#{placeholder}' class='#{options.class}' />"

    render: (name, options, data)->
      #console.log "OFFICE: data: ", data
      data ?= {}
      options = $.extend({label: false}, options)
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.email.input(name, options)
      key = options.key || name

      office_inputs_wrap = inputs.office.render_inputs(key, data)
      has_data = data && ((data.city && data.city.length) || (data.address && data.address.length) || (data.phones && data.phones.length && data.phones[0].length) ) && true
      preview_mode = has_data
      preview_mode_class = if preview_mode then "preview-mode" else ""
      save_button_disabled_class = if has_data then "" else "disabled"

      office_controls_str = "<div class='office-controls'><div class='office-control office-control-save #{save_button_disabled_class}'>#{t("save_office")}</div><div class='office-control office-control-add'>#{t("add_office")}</div><div class='office-control office-control-edit'>#{svg_images.edit}</div><div class='office-control office-control-remove'>#{t("remove_office")}</div></div>"
      help = inputs.base.help(name, options)
      preview_str = if preview_mode then inputs.office.render_locked(data) else ""
      preview_wrap = "<div class='office-preview'>#{preview_str}</div>"


      "<div #{wrap_attributes} class='input register-input input-office #{preview_mode_class}' data-key='#{key}'>#{label}#{preview_wrap}#{office_inputs_wrap}#{office_controls_str}#{help}</div>"


    render_inputs: (key, data)->
      office_inputs_str = ""

      office_inputs_str += inputs.string.render("city",
        {key: "#{key}.city", autocomplete: "address-line1"},
        data.city)
      office_inputs_str += inputs.string.render("address",
        {key: "#{key}.address", autocomplete: "address-line2"}, data.address)
      office_inputs_str += inputs.phones.render("phones", {key: "#{key}.phones"}, data.phones)
      "<div class='office-inputs'>#{office_inputs_str}</div>"

    render_locked: (obj)->
      return "" if !obj
      phones = obj.phones
      if phones && phones.filter
        phones = phones.filter(
          (a)->
            a && a.length > 0
        )
      #console.log "DATA: city: ", obj.city, "; address: ", obj.address, "; phones: ", phones
      return "" if (!obj.city || !obj.city.length) && (!obj.address || !obj.address.length) && (!phones || !phones.length)

      city_str = if obj.city && obj.city.length > 0 then "<p><span>#{t('attributes.city')}:</span>#{obj.city}</p>" else ""
      address_str = if obj.address && obj.address.length > 0 then "<p><span>#{t('attributes.address')}:</span>#{obj.address}</p>" else ""
      phones_str = if phones && phones.length then "<p><span>#{t('attributes.phones')}:</span>#{phones.join("<br/>")}</p>" else ""
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


render_company_name_block = (company_name)->
  company_name = t("placeholders.name") if !company_name || !company_name.length
  "<div class='columns company-name-column'><div class='company-name'>#{company_name}</div></div>"

render_company_form = (data, render_controls = false)->
  data ?= {}
  company_name_str = render_company_name_block(data.name)
  window.available_industries ?= $(".cabinet-container").attr("data-available-industries").split(",")
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



set_input_presence_classes = ()->
  $input_wrap = $(this)
  value = $input_wrap.find("input, textarea").val()

  empty = !value || !value.length
  add_presence_class = if empty then "empty" else "not-empty"
  remove_presence_class = if empty then "not-empty" else "empty"
  console.log "set_input_presence_classes: add_presence_class: ", add_presence_class, "remove_presence_class: ", remove_presence_class
  $input_wrap.changeClasses(add_presence_class, remove_presence_class)

validateEmail = (email)->
  re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);


validate_input__update_dom = (value, valid, add_presence_class, remove_presence_class)->
  #console.log "validate_input__update_dom: args: ", arguments
  console.log "validate_input__update_dom: value: ", value, "; valid: ", valid, "; add_presence_class: ", add_presence_class
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
    value = $input_wrap.find("input, textarea").val()
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
        valid = check_email(value,
          (data)->
            local_valid = !data.exists
            console.log "local_valid: ", local_valid
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
          validate_input__update_dom.call($input_wrap, value, valid, add_presence_class, remove_presence_class)

          if valid == false
            append_email_exists_error_message.call($input_wrap)
      else
        valid = check_email(value)


      return valid


    if !valid
      console.log "invalid: clear email exists"
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



      val = $input.find("input, textarea, select").val()


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


      #console.log "k: ", k

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

window.validate_inputs = (update_dom = false, handler)->

  valid = true
  all_valid = true
  $(this).each(
    ()->
      #console.log "validate"
      #alert("validate_inputs: #{$(this).attr('data-key')}")
      if valid == true || update_dom

        valid = validate_input.call(this, update_dom, handler)

        if !valid
          all_valid = false
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

    if $active_step_content.index() == 1
      window.steps_json = steps_to_json()
      render_summary(steps_json)
  if valid_step != true
    return

  navigate_step.call($active_step_content, direction)


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

$document.on "keyup blur change", ".input", ()->
  $input = $(this)
  if $input.filter("[validation]").length
    validate_input.call($input, true)
  else
    set_input_presence_classes.call($input)


$document.on "change", ".input-select-with-custom-value select", ()->
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




$document.on "click", ".office-control-save", ()->
  $button = $(this)
  return if $button.hasClass("disabled")

  $office = $button.closest(".input-office")
  office_index = $office.index()
  $company = $office.closest(".company")
  company_json = form_to_json.call($company)
  data = company_json.offices[office_index]
  console.log "OFFICES: ", company_json.offices

  str = inputs.office.render_locked(data)
  $office_preview = $office.find(".office-preview")

  if $office_preview.length > 0
    $office_preview.html(str)
  else
    $office_preview = $("<div class='office-preview'>#{str}</div>")
    $office.prepend($office_preview)

  $office.addClass("preview-mode")



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



  show_remove_company_confirm_popup($company)

$document.on "click", ".office-control-remove", ()->
  $button = $(this)
  $office = $button.closest(".input-office")

  show_remove_office_confirm_popup($office)



$document.on "click", ".office-control-edit", ()->
  $(this).closest(".input-office").removeClass("preview-mode")

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


$document.on "click", ".office-control-add", ()->
  $office = $(this).closest(".input-office")
  new_office_str = inputs.office.render("office", {key: "offices[]"}, {})
  $new_office = $(new_office_str)
  $new_office.insertAfter($office)
  inputs.phone.initialize()

$document.on "click", ".remove-company-popup .btn-remove-company-ok", (e)->
  e.preventDefault()
  $popup = $(this).closest(".remove-company-popup")
  removing_popup = $popup.data("data_removing_popup")

  if !removing_popup
    $popup.data("data_removing_popup", true)

    console.log "remove popup"
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

  console.log "check_email: ", email

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

update_dom_for_email_presence = (data)->
  $input_wrap = $("#registration-user .input-email")
  if data.exists
    $input_wrap.changeClasses(["invalid", "invalid-email-exists"], ["valid"])
    $error_message = $input_wrap.find(".email-exists-error-message")
    if !$error_message.length
      $input_wrap.append("<span class='email-exists-error-message'>Користувач з таким email'ом email вже існує</span>")
  else
    $input_wrap.changeClasses(["valid"], ["invalid", "invalid-email-exists"])



###
$document.on "blur keyup change", "#registration-user .input-email input", ()->
  #console.log "event"
  $input = $(this)
  delay("check_email",
    ()->
      email = $input.val()
      if check_email(email, update_dom_for_email_presence)
        update_dom_for_email_presence(window.email_check)

  , 1000)

###

