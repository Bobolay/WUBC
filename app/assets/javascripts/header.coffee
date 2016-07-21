classes = {
  scrolled: "scrolled"
  scroll_larger_than_header_height: "scroll-larger-than-header-height"
}

header_selector = ".header-container"
banner_selector = ""



setClosingTimeout = ()->

  $top_nav = $(this)
  visibility_duration = 2000
  window.top_nav_timeout =  setTimeout(
    ()->
      #alert("setClosingTimeout")
      window.top_nav_timeout = false
      if !window.top_nav_locked

        $top_nav.removeClass(classes.scrolled)

    visibility_duration
  )

handle_scroll = (e)->
  if e && e.ctrlKey
    alert("ctrl")
  # top nav
  $banner = $(banner_selector)
  banner_height = $banner.height()

  scroll_top = $("body").scrollTop() || $(window).scrollTop()
  $top_nav = $(header_selector)
  top_nav_height = $top_nav.height()

  if scroll_top > top_nav_height
    $top_nav.addClass(classes.scroll_larger_than_header_height)
  else
    $top_nav.removeClass(classes.scroll_larger_than_header_height)

  scrolled_class = classes.scrolled
  visible_class = "visible"

  if e && e.scrollTopDelta
    delta = e.scrollTopDelta
  else
    delta = e

  $("body").attr("header_timeout")
  #console.log "delta: ", delta
  if scroll_top > banner_height && delta < 0 && !$("body").hasClass("navigation_move")
    $top_nav.addClass(scrolled_class)
    if window.top_nav_timeout
      clearTimeout(window.top_nav_timeout)

    setClosingTimeout.apply($top_nav)
  else
    $top_nav.removeClass(scrolled_class)

  if scroll_top <= banner_height
    $top_nav.addClass(visible_class)
  else
    $top_nav.removeClass(visible_class)





  # top banner


  handle_top_banner = false
  if handle_top_banner
    $banner_title = $(".title_page:not(.disable-scroll)")
    if $banner_title.length
      ratio = 0.6
      current_translate = $banner_title.data("translateY") || 0
      future_translate = current_translate + delta * ratio

      $banner_title.data("translateY", future_translate)
      $banner_title.css("transform", "translateY(#{future_translate}px)")

$("body").on "mouseover", "#{header_selector}.scrolled, div.top-nav.scrolled *", ()->
  window.top_nav_locked = true

$("body").on "mouseout", "#{header_selector}.scrolled", (e)->
  $target = $(e.relatedTarget)
  if $target.closest(".navigationleft").length == 0 && $target.closest(".header-logo").length == 0
    window.top_nav_locked = false
    setClosingTimeout.apply($(header_selector))



$(window).on "scrolldelta", handle_scroll

handle_scroll(0)


use_custom_scroll_speed = false

if use_custom_scroll_speed

  $(window).on "wheel", (e)->
    console.log "wheel"
    if e.ctrlKey
      return true
    $body = $('body')
    $html_body = $('body, html')
    min_stroll_top = $(banner_selector).height() || 0
    max_scroll_top = $("body").height() - $(window).height()
    $window = $(window)

    current_scroll_top = $body.data("scroll_top") || $window.scrollTop()

    deltaY = e.originalEvent.deltaY


    condition = !$body.hasClass('open-popup') && !$body.data("scroll_in_progress") && (current_scroll_top >= min_stroll_top || deltaY < 0)
    #console.log "condition: ", condition

    if condition


#console.log "wheel: ", e
      e.preventDefault()

      #future_scroll_top = current_scroll_top + deltaY * 2.5
      scroll_direction_up = deltaY < 0

      increment = 100

      if scroll_direction_up
        increment = increment * -1




      future_scroll_top = current_scroll_top + increment
      if future_scroll_top > max_scroll_top
        future_scroll_top = max_scroll_top
      if future_scroll_top < 0
        future_scroll_top = 0

      if current_scroll_top != future_scroll_top
        $body.data("scroll_top", future_scroll_top)

        #console.log "future_scroll_top: ", future_scroll_top

        $html_body.stop()
        $html_body.animate({scrollTop: future_scroll_top}, {
          duration: 600,
          easing: "easeOutExpo"
#easing: "easeOutBack"
        })

$(".menu-button").on "click", ()->
  $('.menu').toggleClass("opened")