
$document.on 'click', ".open-login-popup", (event)->
  if window.current_user
    return

  event.preventDefault()
  $('.sign-in-popup-wrapper').fadeIn('200')

$document.on 'click', ".sign-in-popup-wrapper .close-popup-circle", ->
  $(this).closest('.sign-in-popup-wrapper').fadeOut('100')

$.clickOut(".sign-in-popup-wrapper .login-form-wrapper",
  ()->
    $(".sign-in-popup-wrapper").fadeOut('100')
  {except: ".sign-in-popup-wrapper .login-form-wrapper, .open-login-popup"}
)


###
$document.on "click", ".sign-in-popup-wrapper form button", (e)->
  e.preventDefault()

  data = $(this).closest("form").serializeArray()
  $.ajax(
    url: "/login"
    type: "post"
    data: data
    success: ()->
      #window.location.reload()
    error: (data)->
      #alert("error")
      #window.location = "/login"
      console.log "args: ", arguments
  )

###