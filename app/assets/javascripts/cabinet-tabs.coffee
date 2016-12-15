$(document).on "ready", ->

  $('.tab-header').on 'click', ->

    $(".tabs").children().removeClass("active")
    $(this).addClass("active")

    $index = $(this).index()

    $(".tab-content").removeClass("active")
    $next = $(".tab-content").eq($index)
    $next.addClass("active")

    if $index == 0
      $(".line.active-line-position").css("left", "0")
    if $index == 1
      $(".line.active-line-position").css("left", "33.33333%")
    if $index == 2
      $(".line.active-line-position").css("left", "66.66666%")