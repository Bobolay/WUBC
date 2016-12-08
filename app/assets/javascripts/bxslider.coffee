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
  $('.slider-prev').click ->
    current = slider.getCurrentSlide()
    slider.goToPrevSlide(current) - 1
  $('.slider-next').click ->
    current = slider.getCurrentSlide()
    slider.goToNextSlide(current) + 1



  width = $(".members-container").width()
  console.log(width)
  slider2 = $('.slider-2').bxSlider
    controls: false
    pager: false
    pause: 8000
    infiniteLoop: false
    # auto: true

    onSlideBefore: ($slideElement, oldIndex, newIndex)->
      $('.current-slide .number').text((slider2.getCurrentSlide()+1))
      $('.slide').removeClass('active-slide')
      $($slideElement).addClass('active-slide')

    onSlideAfter: ($slideElement, oldIndex, newIndex)->
      $('.slide').removeClass('active-slide')
      $($slideElement).addClass('active-slide')

  $('.slider-prev').click ->
    current = slider2.getCurrentSlide()
    slider2.goToPrevSlide(current) - 1
  $('.slider-next').click ->
    current = slider2.getCurrentSlide()
    slider2.goToNextSlide(current) + 1



  $blockWidth = $('.companies .company-block').width()
  slider3 = $('.slider-3').bxSlider
    pager: false
    controls: false
    minSlides: 3
    maxSlides: 5
    slideWidth: $blockWidth
    slideMargin: 10
  $('.carousel-slider-prev').click ->
    current = slider3.getCurrentSlide()
    slider3.goToPrevSlide(current) - 1
  $('.carousel-slider-next').click ->
    current = slider3.getCurrentSlide()
    slider3.goToNextSlide(current) + 1



  # slider4 = $('.slider-4').bxSlider
  #   pager: false
  #   controls: false
  #   auto: true
  #   pause: 8000
  # $('.slider-prev').click ->
  #   alert('qwe')
  #   current = slider4.getCurrentSlide()
  #   slider4.goToPrevSlide(current) - 1
  # $('.slider-next').click ->
  #   alert('qwe')
  #   current = slider4.getCurrentSlide()
  #   slider4.goToNextSlide(current) + 1