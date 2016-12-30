$(document).ready ->

  $event_popup = $('.popup-wrapper')

  $(".event-only-for-members").on 'click', ->
    $('.popup-wrapper').fadeIn('200')

  $(".popup-wrapper .go-back").on 'click', ->
    $('.popup-wrapper').fadeOut('100')


  $('.close-popup').on 'click', ->
    $('.popup-wrapper').fadeOut('100')


$.clickOut(".popup-wrapper .popup-block",
 ()->
   $(".popup-wrapper").fadeOut('100')
 {except: ".popup-wrapper .popup-block, .event-only-for-members, .company-control-icon, .subscribe-button"}
)

