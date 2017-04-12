$document.on "click", ".expander", ()->
  $link = $(this)
  $wrap = $link.prev()
  expanded = $wrap.hasClass("expanded")
  if !expanded
    $wrap.addClass("expanded")
  else
    $wrap.removeClass("expanded")

  text_attr_name = if expanded then "data-expand-text" else "data-collapse-text"
  new_text = $link.attr(text_attr_name)
  $link.text(new_text)