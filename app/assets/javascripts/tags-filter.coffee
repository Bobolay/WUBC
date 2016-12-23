$(document).on 'click', ->

  $tag = $('.tags-container .tag')

  $tag.on 'click', ->
    $(this).toggleClass("active")
    $(this).attr("data-tag-id")