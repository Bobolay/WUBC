
$document.on "change", "#user_photo", ()->
  $(".image-loading-in-progress").addClass("show")
  $(this).closest("form").ajaxSubmit({
#target: 'myResultsDiv'
    success: (data)->
#console.log "RESULT: ", arguments
#window.location.reload()
      $cabinet_avatar = $(".cabinet-avatar")
      $cabinet_img_background = $cabinet_avatar.find(".img-background")
      if $cabinet_img_background.length
        $cabinet_img_background.css(
          "background-image", "url('#{data.cabinet_avatar_url}')"
        )
      else
        bg = "url(#{data.cabinet_avatar_url})"
        $cabinet_avatar.append("<div class='img-background' style='background-image: #{bg}'></div>")

      $cabinet_avatar.removeClass("no-photo")

      $(".login-field .user-icon, .menu-user-block .user-avatar").each(
        ()->
          $img = $(this).find("img")
          if $img.length
            $img.attr(
              "src", data.small_avatar_url
            )

          else
            $(this).append("<img src='#{data.small_avatar_url}' />")
            $(this).addClass("has-photo")
      )


      $(".image-loading-in-progress").removeClass("show")

  })
