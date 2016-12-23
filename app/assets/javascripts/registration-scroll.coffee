$document.on "ready page:load", ()->

  $html_and_body = $('body, html')

  if $html_and_body.

  animate = ()->

    $html_and_body.animate({scrollTop: $('.registration-container').offset().top}, {
      duration: 2000,
      easing: "easeInOutQuart"
    })

  if $('body').hasClass('registrations__new')

    setTimeout (->
      animate()
    ), 3000