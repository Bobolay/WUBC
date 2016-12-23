$(document).on 'ready', ->

  $tag = $('.tags-container .tag')

  $tag.on 'click', ->

    $(this).toggleClass("active")
    $tag_id = $(this).attr("data-tag-id")


    $('.article').css('display', 'none')

  #     show   all   articles

  if !$tag.hasClass('active')
    $('.article').css('display', 'block')
