$(->
  width = window.innerWidth
  $(".comment").each(()->
    length=$(this).text().length
    if length>200 && width<640
      $(this).text($(this).text().substr(0,200)+'...')
  )
)