$document.on 'click', '.tags-container .tag', ()->

  $(this).toggleClass("active")
  tag_ids = $(this).closest(".tags-container").find(".tag.active").map(
    ()->
      $(this).attr("data-tag-id")
  ).toArray()
  #tag_ids = $(this).attr("data-tag-id")

  console.log("TAG_IDS: ", tag_ids)

  if !tag_ids.length
    $(".article.hide").removeClass("hide")
    return

  $articles = $('.article')
  $articles_to_show = $articles.filter(
    ()->
      article_tag_ids = $(this).attr("data-tag-ids").split(',')
      console.log "article_tag_ids: ", article_tag_ids
      matched = false
      for id in article_tag_ids
        console.log "article_tag_id: ", id, "; checked_tag_ids: ", tag_ids, "matched: ", tag_ids.indexOf(id)
        matched = true if tag_ids.indexOf(id) >= 0

      matched
  )

  $articles.addClass('hide')

  $articles_to_show.removeClass('hide')



    

