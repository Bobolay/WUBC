$document.on "mouseenter mouseout", ".btn *", (e)->
  e.stopImmediatePropagation()

$document.on "mouseenter", ".btn", (e)->
  e.stopPropagation()

  $button = $(this)
  #$button.removeClass('out').addClass('over')
  current_time = Date.now()
  last_time = $button.data("last_mouse_in")
  #console.log "#{e.type}", (if last_time then current_time - last_time else 0), "e.target: ", e.target, "; event: ", e

  $button.data("last_mouse_in", current_time)
  delay("button_mouse",
    ()->
      $button.removeClass('out').addClass('over')
    800
    true
  )



$document.on "mouseleave", ".btn", (e)->
  e.stopPropagation()
  $button = $(this)

  last_time = $button.data("last_mouse_in")
  current_time = Date.now()

  $button.data("last_mouse_in", null)

  if last_time
    time_diff = current_time - last_time


    #$button.removeClass('over').addClass('out')
    #console.log "#{e.type}; time_diff", time_diff, "e.target: ", e.target, "; event: ", e
    if time_diff >= 300
      delay("button_mouse"
        ()->
          $button.removeClass('over').addClass('out')
        800
        true
      )
