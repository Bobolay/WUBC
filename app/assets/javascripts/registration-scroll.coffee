animate_registration_scroll = ()->
  $html_and_body = $('body, html')
  $html_and_body.animate({scrollTop: $('.registration-container').offset().top}, {
    duration: 2000,
    easing: "easeInOutQuart"
  })

$document.on "ready page:load", ()->
  if $('body').hasClass('registrations__new')
    setTimeout(animate_registration_scroll, 3000)
