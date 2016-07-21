$(document).ready ->
  slider = $('.slider-1').bxSlider
    controls: false
    pager: false
    infiniteLoop: true
    hideControlOnEnd: true
    speed: 500
    pause: 7000
    auto: true
    infiniteLoop: true
    onSlideAfter: ->
        $('.current-slide .number').text((slider.getCurrentSlide()+1))
  $('.slider-prev').click ->
    current = slider.getCurrentSlide()
    slider.goToPrevSlide(current) - 1
  $('.slider-next').click ->
    current = slider.getCurrentSlide()
    slider.goToNextSlide(current) + 1

$(document).ready ->
  slider2 = $('.slider-2').bxSlider
    controls: false
    pager: false
    infiniteLoop: true
    hideControlOnEnd: true
    speed: 500
    pause: 9000
    minSlides: 1
    maxSlides: 3
    slideWidth: 300
    slideMargin: 50
    auto: true
    infiniteLoop: true
    onSlideAfter: ->
      $('.current-slide .number').text((slider2.getCurrentSlide()+1))
  width = $(".members-container").width()
  current = slider2.getCurrentSlide()
  current.css("width", "700")
  $('.slider-prev').click ->
    # current = slider2.getCurrentSlide()
    slider2.goToPrevSlide(current) - 1
  $('.slider-next').click ->
    # current = slider2.getCurrentSlide()
    slider2.goToNextSlide(current) + 1


$(document).ready ->
  $blockWidth = $('.companies .company-block').width()
  slider3 = $('.slider-3').bxSlider
    pager: false
    controls: false
    minSlides: 1
    maxSlides: 5
    slideWidth: $blockWidth
    slideMargin: 10
  $('.carousel-slider-prev').click ->
    current = slider3.getCurrentSlide()
    slider3.goToPrevSlide(current) - 1
  $('.carousel-slider-next').click ->
    current = slider3.getCurrentSlide()
    slider3.goToNextSlide(current) + 1