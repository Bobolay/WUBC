$("body").on "click", ".choose-option", ()->
  $('.current-events svg').toggleClass('rotate')
  $('.expand-field').toggleClass('expand')
  $('.expand-field p').toggleClass('show-it')
