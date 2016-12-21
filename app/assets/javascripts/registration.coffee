$document.on "click", ".prev-step-button, .next-step-button", (e)->
  e.preventDefault()
  $button = $(this)
  direction = if $button.hasClass("prev-step-button") then 'prev' else 'next'
  $step_headers = $(".step-headers")
  $active_step_header = $step_headers.children().filter(".active")
  $active_step_header.removeClass("active")
  $active_step_header[direction]().addClass("active")

  $step_contents = $(".step-contents")
  $active_step_content = $step_contents.children().filter(".active")
  $active_step_content.removeClass("active")
  $active_step_content[direction]().addClass("active")


