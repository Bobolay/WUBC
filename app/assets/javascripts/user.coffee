ajax_link = (opts)->
  href = $(this).attr("href")
  method = $(this).attr("data-method")
  options = $.extend(opts, {
    url: href
    method: method
  })
  $.ajax(options)


$("body").on "click", ".logout-link", ()->
  ajax_link.call(this, {
    complete: ()->
      window.location = "/"
  })