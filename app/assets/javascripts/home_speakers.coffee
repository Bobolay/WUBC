register_speaker_click_handler = ()->
  $document. on "click", ".home-speaker-column", (e)->

    $this = $(this)
    $speaker_block = $this.closest(".home-speaker-column")
    $bg_block = $(this).find(".img-background")
    url = $bg_block.attr("href")
    $target = $(e.target)


    if $target.hasClass("hover-text") || $target.hasClass("hover-block")
      #alert("hover-text")
      if $speaker_block.data("clicked")
        e.preventDefault()
        window.location = url
      else
        e.preventDefault()
        $speaker_block.data("clicked", true)
    else if $target.hasClass("img-background")
      #url = $this.attr("href")
      if url && url.length
        if !$speaker_block.data("clicked")
          $speaker_block.data("clicked", true)
          e.preventDefault()
        else
          $speaker_block.data("clicked", null)
          #e.preventDefault()




    #if url url.length
    #  return

    #if url && url.length
      #window.location = url
    #$bg_block = $(this).find("a.img-background")


if is_touch_device()
  register_speaker_click_handler()

$.clickOut(".home-speaker-column",
  ()->
    $(this).data("clicked", null)
)