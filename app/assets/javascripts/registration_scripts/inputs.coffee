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
        options_html += "<option value='#{opt}' #{selected_str} >#{opt}</option>"

      "<select #{readonly_str} name='#{html_name}' data-placeholder='#{placeholder}' class='#{options.class}' #{selected_str}>#{options_html}</select>"

    render: (name, options, data)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      key = options.key || name
      input_str = inputs.select_with_custom_value.input(name, options, data)
      help = inputs.base.help(name, options)
      "<div #{wrap_attributes} class='input register-input input-select-with-custom-value' data-key='#{key}'>#{label}#{input_str}#{help}</div>"

    initialize: ()->
      $(".input.input-select-with-custom-value:not(.select-initialized)").each(
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
      $(".input-social:not(.initialized)").addClass("initialized").filter(
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
      $(".datepicker:not(.initialized)").addClass("initialized").datepicker({
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
        autoclose: true
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

  personal_helpers: {
    render: (name, options, data)->
      personal_helper_inputs_str = ""
      label = inputs.base.label(name, options)
      personal_helper_options = options.personal_helper_options || {}
      key = options.key || name
      personal_helper_options.key = "#{key}[]"
      if data && data.length
        for personal_helper_data in data
          personal_helper_inputs_str += inputs.personal_helper.render("personal_helper", personal_helper_options, personal_helper_data)
      else
        personal_helper_inputs_str += inputs.personal_helper.render("personal_helper", personal_helper_options)
      personal_helper_inputs_str = "<div class='inputs-collection-inputs'>#{personal_helper_inputs_str}</div>"

      inputs_collection_controls = ""
      help = inputs.base.help(name, options)
      "<div class='inputs-collection personal-helpers inputs-collection-single-input' data-key='#{key}'>#{label}#{personal_helper_inputs_str}#{inputs_collection_controls}#{help}</div>"
  }

  personal_helper: {

    render: (name, options, data)->
      data ?= {}
      options = $.extend({label: false}, options)
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.email.input(name, options)
      key = options.key || name

      personal_helper_inputs_wrap = inputs.personal_helper.render_inputs(key, data)
      has_data = data && ((data.first_name && data.first_name.length) || (data.last_name && data.last_name.length) || (data.email && data.email.length) || (data.phones && data.phones.length && data.phones[0].length) ) && true
      preview_mode = has_data
      preview_mode_class = if preview_mode then "preview-mode" else ""
      save_button_disabled_class = if has_data then "" else "disabled"

      personal_helper_controls_str = "<div class='personal-helper-controls'><div class='personal-helper-control personal-helper-control-save #{save_button_disabled_class}'>#{t("save_personal_helper")}</div><div class='personal-helper-control personal-helper-control-add'>#{t("add_personal_helper")}</div><div class='personal-helper-control personal-helper-control-edit'>#{svg_images.edit}</div><div class='personal-helper-control personal-helper-control-remove'>#{t("remove_personal_helper")}</div></div>"
      help = inputs.base.help(name, options)
      preview_str = if preview_mode then inputs.personal_helper.render_locked(data) else ""
      preview_wrap = "<div class='personal-helper-preview'>#{preview_str}</div>"


      "<div #{wrap_attributes} class='input register-input input-personal-helper #{preview_mode_class}' data-key='#{key}'>#{label}#{preview_wrap}#{personal_helper_inputs_wrap}#{personal_helper_controls_str}#{help}</div>"


    render_inputs: (key, data)->
      personal_helper_inputs_str = ""

      personal_helper_inputs_str += "<div class='columns medium-6'>" + inputs.string.render("first_name",
        {key: "#{key}.first_name"},
        data.first_name)
      personal_helper_inputs_str += inputs.string.render("last_name",
        {key: "#{key}.last_name"}, data.last_name)
      personal_helper_inputs_str += "</div>"
      personal_helper_inputs_str += "<div class='columns medium-6'>"
      personal_helper_inputs_str += inputs.email.render("email",
        {key: "#{key}.email", autocomplete: "address-line2", label: "E-mail"}, data.email)

      personal_helper_inputs_str += inputs.phones.render("phones", {key: "#{key}.phones"}, data.phones)
      personal_helper_inputs_str += "</div>"

      "<div class='personal-helper-inputs'><div class='row'>#{personal_helper_inputs_str}</div></div>"


    render_locked: (obj)->
      return "" if !obj
      phones = obj.phones
      if phones && phones.filter
        phones = phones.filter(
          (a)->
            a && a.length > 0
        )
      #console.log "DATA: city: ", obj.city, "; address: ", obj.address, "; phones: ", phones
      return "" if (!obj.first_name || !obj.first_name.length) && (!obj.last_name || !obj.last_name.length) && (!obj.email || !obj.email.length) && (!phones || !phones.length)

      first_name_str = if obj.first_name && obj.first_name.length > 0 then "<p><span>#{t('attributes.first_name')}:</span>#{obj.first_name}</p>" else ""
      last_name_str = if obj.last_name && obj.last_name.length > 0 then "<p><span>#{t('attributes.last_name')}:</span>#{obj.last_name}</p>" else ""
      email_str = if obj.email && obj.email.length > 0 then "<p><span>#{t('attributes.email')}:</span>#{obj.email}</p>" else ""
      phones_str = if phones && phones.length then "<p><span>#{t('attributes.phones')}:</span>#{phones.join("<br/>")}</p>" else ""
      "<div class='filled-info'>#{first_name_str}#{last_name_str}#{email_str}#{phones_str}</div>"

  }

  offices: {
    render: (name, options, data)->
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