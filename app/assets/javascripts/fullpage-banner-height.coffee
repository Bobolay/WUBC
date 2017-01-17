$(document).on "ready page:load", ->

  $screenWidth = $(window).width()
  $screenHeight = $(window).height()

  $('.home-banner').css('height', $screenHeight + 'px')

  if $screenWidth > 640

    $(window).on "orientationchange", ->
      #     S E T     F U L L P A G E     B A N N E R     H E I G H T
      $screenHeight = $(window).height()
      $('.home-banner').css('height', $screenHeight + 'px')