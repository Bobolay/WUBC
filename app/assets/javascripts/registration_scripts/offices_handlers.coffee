$document.on "keyup blur change", ".input-office input", ()->
  $office = $(this).closest(".input-office")
  city = $office.find("input[name=city]").val()
  address = $office.find("input[name=address]").val()
  phones = $office.find("input[name=phone]").map(
    ()->
      $(this).val()
  ).toArray().filter(
    (a)->
      a && a.length > 0 && a.indexOf("_") < 0
  )
  has_data = ((city && city.length) || (address && address.length) || (phones && phones.length && phones[0].length) ) && true

  $save_button = $office.find(".office-control-save")
  $save_button.removeClass("disabled") if has_data && $save_button.hasClass("disabled")
  $save_button.addClass("disabled") if !has_data && !$save_button.hasClass("disabled")


$document.on "click", ".office-control-save", ()->
  $button = $(this)
  return if $button.hasClass("disabled")

  $office = $button.closest(".input-office")
  office_index = $office.index()
  $company = $office.closest(".company")
  company_json = form_to_json.call($company)
  data = company_json.offices[office_index]
  #console.log "OFFICES: ", company_json.offices

  str = inputs.office.render_locked(data)
  $office_preview = $office.find(".office-preview")

  if $office_preview.length > 0
    $office_preview.html(str)
  else
    $office_preview = $("<div class='office-preview'>#{str}</div>")
    $office.prepend($office_preview)

  $office.addClass("preview-mode")


$document.on "click", ".office-control-remove", ()->
  $button = $(this)
  $office = $button.closest(".input-office")

  show_remove_office_confirm_popup($office)



$document.on "click", ".office-control-edit", ()->
  $(this).closest(".input-office").removeClass("preview-mode")

$document.on "click", ".office-control-add", ()->
  $office = $(this).closest(".input-office")
  new_office_str = inputs.office.render("office", {key: "offices[]"}, {})
  $new_office = $(new_office_str)
  $new_office.insertAfter($office)
  inputs.phone.initialize()


$document.on "click", ".remove-office-popup .btn-remove-office-ok", (e)->
  e.preventDefault()
  $wrap = $(this).closest(".popup-wrapper")
  company_index = $wrap.attr("data-company-index")
  office_index = $wrap.attr("data-office-index")
  $company = $(".company").eq(company_index)
  $offices_input = $company.find(".offices")
  $office_inputs_wrap = $offices_input.find(".inputs-collection-inputs")
  $office = $office_inputs_wrap.children().eq(office_index)
  $office.remove()
  put_companies() if is_cabinet


  if !$office_inputs_wrap.children().length
    new_office_str = inputs.office.render("office", {key: "offices[]"}, {})

    $office_inputs_wrap.append(new_office_str)

  close_popup.call($wrap)


