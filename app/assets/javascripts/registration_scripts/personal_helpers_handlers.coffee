$document.on "keyup blur change", ".input-personal-helper input", ()->
  $personal_helper = $(this).closest(".input-personal-helper")
  first_name = $personal_helper.find("input[name=first_name]").val()
  last_name = $personal_helper.find("input[name=last_name]").val()
  email = $personal_helper.find("input[name=email]").val()
  phones = $personal_helper.find("input[name=phone]").map(
    ()->
      $(this).val()
  ).toArray().filter(
    (a)->
      a && a.length > 0 && a.indexOf("_") < 0
  )
  has_data = ((first_name && first_name.length) || (last_name && last_name.length) || (email && email.length) || (phones && phones.length && phones[0].length) ) && true

  $save_button = $personal_helper.find(".personal-helper-control-save")
  $save_button.removeClass("disabled") if has_data && $save_button.hasClass("disabled")
  $save_button.addClass("disabled") if !has_data && !$save_button.hasClass("disabled")


$document.on "click", ".personal-helper-control-save", ()->
  $button = $(this)
  return if $button.hasClass("disabled")

  $personal_helper = $button.closest(".input-personal-helper")
  personal_helper_index = $personal_helper.index()
  $user = $("#registration-user")
  user_json = form_to_json.call($user)
  data = user_json.personal_helpers[personal_helper_index]

  str = inputs.personal_helper.render_locked(data)
  $personal_helper_preview = $personal_helper.find(".personal-helper-preview")

  if $personal_helper_preview.length > 0
    $personal_helper_preview.html(str)
  else
    $personal_helper_preview = $("<div class='personal-helper-preview'>#{str}</div>")
    $personal_helper.prepend($personal_helper_preview)

  $personal_helper.addClass("preview-mode")


$document.on "click", ".personal-helper-control-remove", ()->
  $button = $(this)
  $personal_helper = $button.closest(".input-personal-helper")

  show_remove_personal_helper_confirm_popup($personal_helper)



$document.on "click", ".personal-helper-control-edit", ()->
  $(this).closest(".input-personal-helper").removeClass("preview-mode")

$document.on "click", ".personal-helper-control-add", ()->
  $personal_helper = $(this).closest(".input-personal-helper")
  new_personal_helper_str = inputs.personal_helper.render("personal_helper", {key: "personal_helpers[]"}, {})
  $new_personal_helper = $(new_personal_helper_str)
  $new_personal_helper.insertAfter($personal_helper)
  inputs.phone.initialize()


$document.on "click", ".remove-personal-helper-popup .btn-remove-personal-helper-ok", (e)->
  e.preventDefault()
  $wrap = $(this).closest(".popup-wrapper")
  personal_helper_index = $wrap.attr("data-personal-helper-index")
  $user = $("#registration-user")
  $personal_helpers_input = $user.find(".personal-helpers")
  $personal_helper_inputs_wrap = $personal_helpers_input.find(".inputs-collection-inputs")
  $personal_helper = $personal_helper_inputs_wrap.children().eq(personal_helper_index)
  $personal_helper.remove()
  put_profile() if is_cabinet


  if !$personal_helper_inputs_wrap.children().length
    new_personal_helper_str = inputs.personal_helper.render("personal_helper", {key: "personal_helpers[]"}, {})

    $personal_helper_inputs_wrap.append(new_personal_helper_str)

  close_popup.call($wrap)


