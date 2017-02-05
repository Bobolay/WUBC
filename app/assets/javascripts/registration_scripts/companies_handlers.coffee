
handle_save_button_click = ($button, $form)->
  $button.css({display: "inline-block"})
  if $form.hasClass("has-explicitly-unsaved-changes")
    $form.removeClass("has-explicitly-unsaved-changes")

  setTimeout(
    ()->
      $button.css({display: ""})
    500
  )

  $form_inputs = $form.find(".input[validation]")
  validate_inputs.call($form_inputs, true)



$document.on "click", ".company-control-add, .role-company-control-add", ()->
  $button = $(this)
  $company = $button.closest(".company")
  company_str = render_company_form({}, true)
  $new_company = $(company_str)
  $new_company.insertAfter($company)
  initialize_inputs()

$document.on "click", ".company-control-remove", ()->
  $button = $(this)
  $company = $button.closest(".company")

  show_remove_company_confirm_popup($company)



$document.on "click", ".remove-company-popup .btn-remove-company-ok", (e)->
  e.preventDefault()
  $popup = $(this).closest(".remove-company-popup")
  removing_popup = $popup.data("data_removing_popup")

  if !removing_popup
    $popup.data("data_removing_popup", true)

    #console.log "remove popup"
    $popup.fadeOut('100')
    setTimeout(
      ()->
        $popup.data("data_removing_popup", false)
      500
    )

    i = $popup.attr("data-company-index")
    $company = $("#cabinet-companies .company").eq(i)
    $company.remove()
    put_companies()
  else
    return




$document.on "click", ".company-control-save", ()->
  $button = $(this)
  $form = $button.closest(".company")
  handle_save_button_click($button, $form)

$document.on "click", ".cabinet-profile-control-save", ()->
  $button = $(this)
  $form = $button.closest("#cabinet-profile-form")
  handle_save_button_click($button, $form)
