$document.on 'ready', ->

  $('.choose-option').on 'click', ->
    $('.current-events').toggleClass('active')
    $('.expand-field').toggleClass('expand')
    $('.expand-field p').toggleClass('show-it')

  $('.expand-field .future').on 'click', ->
    $('.event').removeClass('hide')
    $('.past-event').addClass('hide')

  $('.expand-field .past').on 'click', ->
    $('.event').addClass('hide')
    $('.past-event').removeClass('hide')

  $('.choose-option').on 'click', ->
    $('.event').removeClass('hide')
    $('.past-event').removeClass('hide')