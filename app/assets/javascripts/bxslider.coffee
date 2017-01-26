$(document).on "ready page:load", ->

  #     F I R S T     M E E T I N G

  slider = $('.slider-1').bxSlider
    controls: false
    pager: false
    hideControlOnEnd: true
    speed: 500
    pause: 7000
    auto: true
    infiniteLoop: true
  $('.meeting-container .slider-prev, .event-one-wrapper .slider-prev').click ->
    current = slider.getCurrentSlide()
    slider.goToPrevSlide(current) - 1
  $('.meeting-container .slider-next, .event-one-wrapper .slider-next').click ->
    current = slider.getCurrentSlide()
    slider.goToNextSlide(current) + 1

  #     M E M B E R S

  slider2 = $('.slider-2').bxSlider
    controls: false
    pager: false
    pause: 8000
    infiniteLoop: false
    
    onSlideBefore: ($slideElement, oldIndex, newIndex)->
      $('.current-slide .number').text((slider2.getCurrentSlide()+1))
      $('.slide').removeClass('active-slide')
      $($slideElement).addClass('active-slide')

    onSlideAfter: ($slideElement, oldIndex, newIndex)->
      $('.slide').removeClass('active-slide')
      $($slideElement).addClass('active-slide')

  if slider2.getSlideCount
    $('.current-slide .total-slides').text((slider2.getSlideCount()))

  $('.members-container .slider-prev').click ->
    current = slider2.getCurrentSlide()
    slider2.goToPrevSlide(current) - 1
  $('.members-container .slider-next').click ->
    current = slider2.getCurrentSlide()
    slider2.goToNextSlide(current) + 1

  #     C O M P A N I E S

  $blockWidth = $('.companies .company-block').width()
  slider3 = $('.slider-3').bxSlider
    pager: false
    controls: false
    minSlides: 1
    maxSlides: 5
    slideWidth: $blockWidth
    slideMargin: 10
    infiniteLoop: true
  $('.carousel-slider-prev').click ->
    current = slider3.getCurrentSlide()
    slider3.goToPrevSlide(current) - 1
  $('.carousel-slider-next').click ->
    current = slider3.getCurrentSlide()
    slider3.goToNextSlide(current) + 1

  #     A B O U T     U S     S L I D E R

  
  $pager_list = []
  $('#bx-pager-about-us .pager').each(->
    $pager_list.push($(this).text())
    )
  #console.log($pager_list)

  slider4 = $('.slider-4').bxSlider
    pagerCustom: '#bx-pager-about-us'
    controls: false
    auto: true
    pause: 8000
    onSlideBefore: ($slideElement, oldIndex, newIndex)->

      $index = (slider4.getCurrentSlide())

      $('.activity').text($pager_list[$index])


  $('.activity-slider-container .slider-prev').click ->
    current = slider4.getCurrentSlide()
    slider4.goToPrevSlide(current) - 1
  $('.activity-slider-container .slider-next').click ->
    current = slider4.getCurrentSlide()
    slider4.goToNextSlide(current) + 1