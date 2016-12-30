$document.on 'click', '.subscribe, .unsubscribe', (e)->
  e.preventDefault()
  
  subscribe = $(this).hasClass("subscribe")

  event_url = $(".event-one-wrapper").attr("data-url")
  subscribe_url = event_url + "/subscribe"
  unsubscribe_url = event_url + "/unsubscribe"

  if subscribe
    $('.subscribe-popup').fadeIn('300')
    $.ajax(
      dataType: "json"
      url: subscribe_url
    )
    $(".subscribe-button").replaceWith("<a href='#{unsubscribe_url}' class='link subscribe-button unsubscribe'>Відписатися</a>")
  else
    $('.unsubscribe-popup').fadeIn('300')
    $.ajax(
      dataType: "json"
      url: unsubscribe_url
    )

    $(".subscribe-button").replaceWith("<a href='#{subscribe_url}' class='link subscribe-button subscribe'>Відвідати зустріч</a>")


