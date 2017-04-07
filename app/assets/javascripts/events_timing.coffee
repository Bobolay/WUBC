window.select_events = ()->
  $container = $(this)
  now = new Date()
  now_month = now.getMonth() + 1
  now_year = now.getFullYear()
  now_day = now.getDay()
  now_hour = now.getHours()
  now_minute = now.getMinutes()

  $past_and_active_events = $container.find(".event.future-event").filter(
    ()->
      $event = $(this)
      event_date_str = $event.attr("data-date")
      event_date_arr = event_date_str.split(".")

      event_day = parseInt(event_date_arr[0])
      event_month = parseInt(event_date_arr[1])
      event_year = parseInt(event_date_arr[2])

      is_past_date = event_year < now_year || event_month < now_month || event_day < now_day
      return true if is_past_date
      is_event_today = event_year == now_year && event_month == now_month && event_day == now_day

      is_future_date = !is_event_today
      return false if is_future_date




      event_start_time_str = $event.attr("data-start-time")
      event_start_time_arr = event_start_time_str.split(":")
      event_start_hour = parseInt(event_start_time_arr[0])
      event_start_minute = parseInt(event_start_time_arr[1])

      is_future_time = now_hour < event_start_hour || now_minute < event_start_minute

      return !is_future_time
  )


init_events_page = ()->
  $container = $("body.events__index .events-row")
  $events = select_events.call($container)
  $events.changeClasses(["past-event"], ["future-event"])
  $events.find(">div").changeClasses(["past-event"], ["future-event"])

init_home_events = ()->


$document.on "ready page:load", init_events_page

