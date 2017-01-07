$(document).ready ->

  $event_popup = $('.popup-wrapper')

  $(".event-only-for-members").on 'click', ->
    $('.popup-wrapper').fadeIn('200')

  $(".popup-wrapper .go-back").on 'click', ->
    $('.popup-wrapper').fadeOut('100')


  $('.close-popup').on 'click', ->
    $('.popup-wrapper').fadeOut('100')


window.close_popup = (e)->
  e.preventDefault() if e && e.preventDefault
  $(this).closest(".popup-wrapper").fadeOut('100')

#$.clickOut(".remove-company-popup .popup-block",
#  close_popup
#  {except: ".company-control-icon"}
#)

#$.clickOut(".remove-office-popup .popup-block",
#  close_popup
#  {except: ".office-control-remove"}
#)

#$.clickOut(".subscribe-popup .popup-block",
#  ()->
#    alert("hello")
#  {except: ".subscribe-button, .link, .subscribe"}
#)
#
#$.clickOut(".popup-wrapper.unsubscribe-popup .popup-block",
#  close_popup
#  {except: ".unsubscribe-button"}
#)

$document.on "click",
  ".subscribe-popup, .unsubscribe-popup, .remove-company-popup, .remove-office-popup"
  (e)->
    $(e.target).filter(".popup-wrapper").fadeOut('100')

$document.on "click",
  ".popup-wrapper .popup-block .btn-cancel"
  close_popup