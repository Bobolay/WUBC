$document.on 'click', '.tags-container .tag', ()->

  $(this).toggleClass("active")
  tag_ids = $(this).closest(".tags-container").map(
    $(this).attr("data-tag-id")
  ).toArray()
  console.log("tag_id:", tag_id)

  $articles = $('.article')
  $articles_to_show = $articles.filter(
    ()->
      $(this).attr("data-tag-ids").split(',').indexOf(tag_id)
  )


  $articles.addClass('hide')

  $articles_to_show.removeClass('hide')


    

