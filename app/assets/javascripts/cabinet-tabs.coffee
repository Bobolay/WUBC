
$document.on 'click', '.tab-header', ->

  $tab_header = $(this)
  $tab_headers_wrap = $tab_header.closest(".tab-headers")
  $tab_contents_wrap = $tab_headers_wrap.parent().children().filter(".tab-contents")
  $tab_contents = $tab_contents_wrap.children()
  tab_index = $tab_header.index()
  active_tab_index = $tab_headers_wrap.children().filter(".active").index()

  is_step = $tab_headers_wrap.hasClass("step-headers")
  if is_step && tab_index > active_tab_index
    $active_tab_content = $tab_contents.filter(".active")
    $active_tab_content_inputs = $active_tab_content.find(".input[validation]")
    valid = validate_inputs.call($active_tab_content_inputs, true)
    if !valid
      return

    if tab_index == 2 && active_tab_index == 0
      valid_step_2 = validate_inputs.call($tab_contents.eq(1).find(".input[validation]"), true)
      if !valid_step_2
        $tab_headers_wrap.children().removeClass("active")
        $tab_headers_wrap.children().eq(1).addClass("active")
        $tab_contents.filter(".active").removeClass("active")
        $tab_contents.eq(1).addClass("active")

        return




  $tab_headers_wrap.children().removeClass("active")
  $tab_header.addClass("active")


  $tab_contents.filter(".active").removeClass("active")
  $next = $tab_contents.eq(tab_index)
  $next.addClass("active")

  if tab_index == 0
    $(".line.active-line-position").css("left", "0")
  if tab_index == 1
    $(".line.active-line-position").css("left", "33.33333%")
  if tab_index == 2
    $(".line.active-line-position").css("left", "66.66666%")


  if is_step && tab_index == 2
    window.steps_json = steps_to_json()
    render_summary(steps_json)