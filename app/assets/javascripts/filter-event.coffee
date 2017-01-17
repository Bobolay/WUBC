$document.on 'click', '.choose-option', ->
  $('.current-events').toggleClass('active')
  $('.expand-field').toggleClass('expand')
  $('.expand-field p').toggleClass('show-it')

$document.on 'click', '.expand-field .future', ->
  $('.event').removeClass('hide')
  $('.past-event').addClass('hide')

$document.on 'click', '.expand-field .past', ->
  $('.event').addClass('hide')
  $('.past-event').removeClass('hide')

$document.on 'click', '.choose-option', ->
  $('.event').removeClass('hide')
  $('.past-event').removeClass('hide')