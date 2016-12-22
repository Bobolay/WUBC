locales = {
  uk: {
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
    label: (name, options)->
      if options.label == false
        return ""
      if options.label
        s = options.label
      else
        s = t("attributes.#{name}") || name
      "<label class='input-label'>#{s}</label>"
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
      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<input type='text' placeholder='#{placeholder}' class='#{options.class}' />"

    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.string.input(name, options)
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}</div>"

  }

  text: {
    input: (name, options)->

      options = $.extend({}, options)
      placeholder = inputs.base.placeholder(name)
      "<textarea placeholder='#{placeholder}' class='#{options.class}' ></textarea>"
    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      label = inputs.base.label(name, options)
      input_str = inputs.text.input(name, options)
      textarea_corner = "<div class='textarea-corner'></div>"
      "<div #{wrap_attributes} class='input register-input' data-key='#{name}'>#{label}#{input_str}#{textarea_corner}</div>"
  }

  integer: {
    render: ()->
      inputs.string.render.apply(this, arguments)
  }
  date: {
    render: (name, options)->
      wrap_attributes = inputs.base.wrap_attributes(name, options)
      options = $.extend({class: "datepicker"}, options)
      icon_source = svg_images.calendar
      label = inputs.base.label(name, options)
      input_str = inputs.string.input(name, options)
      icon_label = "<label class='icon icon-calendar'>#{icon_source}</label>"
      "<div #{wrap_attributes} class='input register-input'>#{label}#{input_str}#{icon_label}</div>"


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
        onSelect: ()->
          $input_wrap = $(this).closest(".input")
          $input_wrap.addClass("not-empty")

      })
  }
}
render_inputs_to_string = (props)->
  res = ""
  for k, v of props
    type = v.type || "string"
    res += inputs[type].render(k, v)

  res

column = (html_class, props)->
  s = render_inputs_to_string(props)
  "<div class='columns #{html_class}'>#{s}</div>"

window.user_form = column("medium-6", {
  first_name: {}
  middle_name: {}
  last_name: {},
  birth_date: {
    type: "date"
  }
}) +
column( "medium-6", {
  phones: {}
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
    class: "material-input"
    label: false
  }
) +
column("medium-6", {
  industry: {

  }
  description: {
    type: "text"
  }
  region: {}
  position: {}
  employees_count: {
    type: "integer"
  }
}) +
column("medium-6", {
  company_site: {}
  #offices: {
  #  type: "offices"
  #}
  social_networks: {}
})

$("#registration-user").html(user_form)
$("#registration-company").html(company_form)

initialize_inputs = ()->
  inputs.date.initialize()

initialize_inputs()




window.form_to_json = ()->
  obj = {}
  $(this).find(".input").map(
    ()->
      $input = $(this)
      k = $input.attr("data-key")
      if k == undefined
        return
      val = $input.find("input, textarea").val()
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

      if valid
        $input_wrap.changeClasses(["valid"], ["invalid"])
      else
        $input_wrap.changeClasses(["invalid"], ["valid"])
    return valid
  else
    return true


$document.on "click", ".prev-step-button, .next-step-button", (e)->
  e.preventDefault()

  $step_contents = $(".step-contents")
  $active_step_content = $step_contents.children().filter(".active")

  $button = $(this)
  direction = if $button.hasClass("prev-step-button") then 'prev' else 'next'
  if direction == 'next'
    valid_step = validate_inputs.call($active_step_content.find(".input[validation]"), true)

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