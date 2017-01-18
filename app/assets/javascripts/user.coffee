ajax_link = (opts)->
  href = $(this).attr("href")
  method = $(this).attr("data-method")
  options = $.extend(opts, {
    url: href
    method: method
  })
  $.ajax(options)

render_user_components = (user_data)->
  console.log "user_data: ", user_data
  $("body").addClass("logged-in")
  render_header_user(user_data)
  render_menu_and_footer_user(user_data)

render_header_user = (user_data)->
  str = ""
  $header = $(".header-container")
  $login_field = $header.find(".login-field")
  login_field_class = "login-field"
  login_field_class += " logged" if user_data


  if user_data
    user_img_src = user_data.small_avatar || user_data.default_small_avatar
    user_full_name = user_data.first_and_last_name
    str = "<a class='user-icon' href='/cabinet'><img src='#{user_img_src}'/></a><div class='user-info-panel'><a class='user-name' href='/cabinet'>#{user_full_name}</a><a class='logout-link' title='Вийти з особистого кабінету' href='logout' data-method='delete'>Вихід</a></div>"

  else
    str = "<a class='open-login-popup' title='Увійти в свій особистий кабінет'><p>Логін</p>#{svg_images.lock}</a>"
  str = "<div class='#{login_field_class}'>#{str}</div>"

  $login_field.replaceWith(str)


render_footer_user = (user_data)->
render_menu_and_footer_user = (user_data)->
  $parent = $(".login-form-wrap")
  str = ""

  if user_data
    show_icon = !user_data.small_avatar
    user_avatar_class = "user-avatar"
    user_avatar_class += " icon" if show_icon
    user_img_src = user_data.small_avatar || user_data.default_small_avatar
    user_full_name = user_data.first_and_last_name
    str = "<div class='user-block menu-user-block'><a class='#{user_avatar_class}' href='/cabinet'><img src='#{user_img_src}' /></a><div class='user-details'><a class='user-name' href='/cabinet'>#{user_full_name}</a><div class='user-links'><a class='green' href='/cabinet'>Мій акаунт</a><span>|</span><a class='grey logout-link' data-method='delete' href='/logout'>Вихід</a></div></div></div>"

  $parent.html(str)

window.init_user = ()->
  if (window.current_user == null || window.current_user == undefined) && !window.current_user_in_progress
    window.current_user_in_progress = true
    $.ajax(
      url: "/current_user"
      data: {}
      type: "get"
      dataType: "json"
      success: (data)->
        window.current_user = data
        render_user_components(data)

      error: ()->

    )


$document.on "page:load", ()->
  if window.current_user
    render_user_components(window.current_user)

init_user()

console.log "test"


$document.on "click", ".logout-link", ()->
  ajax_link.call(this, {
    complete: ()->
      window.location = "/"
  })