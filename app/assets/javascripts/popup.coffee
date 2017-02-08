window.render_popup = (popup_key, go_back_link, go_back_title, description, button1_class, button1_link, button1_title, button2_class, button2_link, button2_title)->
  popup_content = "<p class='go-back'></p><p class='larger'>#{description}</p><a href='#{button1_link}' class='become-member green-button #{button1_class}'>#{button1_title}</a><a href='#{button2_link}' class='open-login-popup #{button2_class}'>#{button2_title}</a>"
  popup_content_wrap = "<div class='popup-block'>#{popup_content}</div>"
  "<div class='popup-wrapper #{popup_key}-popup'>#{popup_content_wrap}</div>"

window.show_popup = (popup_key)->
  popup_html_args = arguments
  popup_str = render_popup.apply(this, popup_html_args)
  $body = $("body")
  $body.append(popup_str)
  $body.addClass("has-opened-#{popup_key}-popup")

window.get_company_name_or_number = ($company)->
  company_name = $company.find(".company-name").text()
  company_name_input_text = $company.find("[name=name]").val()
  is_default_name = !company_name_input_text || !company_name_input_text.length
  company_name_str = ""
  company_index = $company.index()

  if is_default_name
    company_number = company_index + 1
    company_name_str = "&laquo;" + company_name + "&raquo;" + " (порядковий номер: #{company_number})"
  else
    company_name_str = "&laquo;" + company_name + "&raquo;"

  company_name_str


get_office_name_or_number = ($office)->
  city = $office.find("input[name=city]").val()
  address = $office.find("input[name=address]").val()
  #phones = $office.find("input[name=phone]").val()
  str = ""
  office_number = $office.index() + 1
  office_number_str = "(Порядковий номер: #{office_number})"
  if city.length && address.length
    str = "&laquo;#{city}, #{address}&raquo;"
  else if city.length
    str = "&laquo;#{city}&raquo; #{office_number_str}"
  else if address.length
    str = "&laquo;#{address}&raquo; #{office_number_str}"
  else
    str = office_number_str

  str

get_personal_helper_name_or_number = ($personal_helper)->
  first_name = $personal_helper.find("input[name=first_name]").val()
  last_name = $personal_helper.find("input[name=last_name]").val()
  #phones = $office.find("input[name=phone]").val()
  str = ""
  personal_helper_number = $personal_helper.index() + 1
  personal_helper_number_str = "(Порядковий номер: #{personal_helper_number})"
  if first_name.length && last_name.length
    str = "&laquo;#{first_name} #{last_name}&raquo;"
  else if first_name.length
    str = "&laquo;#{first_name}&raquo; #{personal_helper_number_str}"
  else if last_name.length
    str = "&laquo;#{last_name}&raquo; #{personal_helper_number_str}"
  else
    str = personal_helper_number_str

  str

window.show_remove_company_confirm_popup = ($company)->
  company_index = $company.index()
  company_name_str = get_company_name_or_number($company)

  popup_description = "Ви дійсно хочете видалити назавжди компанію #{company_name_str}?"
  $remove_company_popup = $(".remove-company-popup")

  if !$remove_company_popup.length
    show_popup("remove-company", "", "", popup_description, "btn-remove-company-ok", "", "OK", "btn-cancel btn-remove-company-cancel", "", "Відміна")
    $(".remove-company-popup").attr("data-company-index", company_index)
  else
    current_remove_company_popup_index = parseInt($remove_company_popup.attr("data-company-index"))
    if current_remove_company_popup_index != company_index
      $remove_company_popup.attr("data-company-index", company_index)
    $("body").addClass("has-opened-remove-company-popup")
    $remove_company_popup.find(".larger").html(popup_description)
    $remove_company_popup.fadeIn()
  $remove_company_popup = $(".remove-company-popup")


window.show_remove_office_confirm_popup = ($office)->
  $company = $office.closest(".company")
  company_index = $company.index()
  office_index = $office.index()
  company_name_str = get_company_name_or_number($company)

  office_name_str = get_office_name_or_number($office)

  popup_description = "Ви дійсно хочете видалити офіс #{office_name_str} компанії #{company_name_str}?"
  $remove_company_popup = $(".remove-office-popup")

  if !$remove_company_popup.length
    show_popup("remove-office", "", "", popup_description, "btn-remove-office-ok", "", "OK", "btn-cancel btn-remove-office-cancel", "", "Відміна")
    $(".remove-office-popup").attr("data-company-index", company_index)
    $(".remove-office-popup").attr("data-office-index", office_index)
  else
    current_remove_company_popup_company_index = parseInt($remove_company_popup.attr("data-company-index"))
    current_remove_company_popup_office_index = parseInt($remove_company_popup.attr("data-office-index"))
    if current_remove_company_popup_company_index != company_index || current_remove_company_popup_office_index != office_index
      $remove_company_popup.attr("data-office-index", company_index)
    $("body").addClass("has-opened-remove-office-popup")
    $remove_company_popup.find(".larger").html(popup_description)
    $remove_company_popup.fadeIn()
  $remove_company_popup = $(".remove-office-popup")


window.show_remove_personal_helper_confirm_popup = ($personal_helper)->
  $user = $("#registration-user")
  personal_helper_index = $personal_helper.index()

  personal_helper_name_str = get_personal_helper_name_or_number($personal_helper)

  popup_description = "Ви дійсно хочете видалити особистого помічника #{personal_helper_name_str}?"
  $remove_personal_helper_popup = $(".remove-personal-helper-popup")

  if !$remove_personal_helper_popup.length
    show_popup("remove-personal-helper", "", "", popup_description, "btn-remove-personal-helper-ok", "", "OK", "btn-cancel btn-remove-personal-helper-cancel", "", "Відміна")
    $(".remove-personal-helper-popup").attr("data-personal-helper-index", personal_helper_index)
  else

    current_remove_personal_helper_popup_personal_helper_index = parseInt($remove_personal_helper_popup.attr("data-personal-helper-index"))
    if current_remove_personal_helper_popup_personal_helper_index != personal_helper_index
      $remove_personal_helper_popup.attr("data-personal-helper-index", personal_helper_index)
    $("body").addClass("has-opened-remove-personal-helper-popup")
    $remove_personal_helper_popup.find(".larger").html(popup_description)
    $remove_personal_helper_popup.fadeIn()
  #$remove_personal_helper_popup = $(".remove-office-popup")