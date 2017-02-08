window.navigate_step = (direction)->
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
    url: "/sign-up"
    type: "post"
    data: json
  )

  # alert("вам на пошту надіслано лист з підтвердженням")
  $('.success-popup-wrapper').fadeIn('200')


