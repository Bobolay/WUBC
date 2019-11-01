window.addEventListener('load', ()->
  if !isMobile.phone && !isMobile.tablet
    $bg_video_iframe = $('#bg-video')
    $bg_video_iframe.attr('src', $bg_video_iframe.attr('data-src'))
)

$('#bg-video').on('load', ()->
  $('.video-background').addClass('video-loaded')
)

$(".company_video_btn").modalVideo();