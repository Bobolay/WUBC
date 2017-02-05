
window.validateEmail = (email)->
  re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  return re.test(email);


window.validate_input__update_dom = (value, valid, add_presence_class, remove_presence_class)->
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

window.append_email_exists_error_message = ()->
  $input_wrap = $(this)
  $error_message = $input_wrap.find(".email-exists-error-message")
  if !$error_message.length
    $input_wrap.append("<span class='email-exists-error-message'>Користувач з таким email'ом email вже існує</span>")

window.append_email_ajax_loader = ()->
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
