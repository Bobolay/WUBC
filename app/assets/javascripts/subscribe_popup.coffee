$document.on "ready page:load", (e)->
  init_subscription_buttons()
  #$event_wrapper = $("div.event-one-wrapper")
  #if !$event_wrapper.length
  #  return


$document.on 'click', '.subscribe, .unsubscribe', (e)->
  e.preventDefault()
  
  subscribe = $(this).hasClass("subscribe")
  event_url = $(".event-one-wrapper").attr("data-url")

  if subscribe
    subscribe_url = event_url + "/subscribe"
    $('.subscribe-popup').fadeIn('300')
    $.ajax(
      dataType: "json"
      url: subscribe_url
    )
    replace_subscribe_button_to_unsubscribe()
  else
    unsubscribe_url = event_url + "/unsubscribe"
    $('.unsubscribe-popup').fadeIn('300')
    $.ajax(
      dataType: "json"
      url: unsubscribe_url
    )

    replace_unsubscribe_button_to_subscribe()



