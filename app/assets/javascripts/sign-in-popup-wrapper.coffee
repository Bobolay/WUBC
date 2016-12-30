$(document).ready ->

  $(".open-login-popup").on 'click', ->
    event.preventDefault()
    $('.sign-in-popup-wrapper').fadeIn('200')

  $(".sign-in-popup-wrapper .close-popup-circle").on 'click', ->
    $('.sign-in-popup-wrapper').fadeOut('100')

  $.clickOut(".sign-in-popup-wrapper .login-form-wrapper",
    ()->
      $(".sign-in-popup-wrapper").fadeOut('100')
    {except: ".sign-in-popup-wrapper .login-form-wrapper, .open-login-popup"}
  )