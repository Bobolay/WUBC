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

window.show_remove_company_confirm_popup = ($company)->
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

  popup_description = "Ви дійсно хочете видалити назавжди компанію #{company_name_str}?"
  $remove_company_popup = $(".remove-company-popup")

  if !$remove_company_popup.length
    show_popup("remove-company", "", "", popup_description, "btn-remove-company-ok", "", "OK", "btn-remove-company-cancel", "", "Відміна")
    $(".remove-company-popup").attr("data-company-index", company_index)
  else
    current_remove_company_popup_index = parseInt($remove_company_popup.attr("data-company-index"))
    if current_remove_company_popup_index != company_index
      $remove_company_popup.attr("data-company-index", company_index)
    $("body").addClass("has-opened-remove-company-popup")
    $remove_company_popup.find(".larger").html(popup_description)
    $remove_company_popup.fadeIn()
  $remove_company_popup = $(".remove-company-popup")


