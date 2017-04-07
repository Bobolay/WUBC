check_if_cabinet = ()->
  $("body").hasClass("cabinet__index")


window.is_cabinet = check_if_cabinet()

window.registration_user_form = column("medium-6", {
  first_name: {required: true, autocomplete: "given-name"}
  middle_name: {required: true, autocomplete: "additional-name"}
  last_name: {required: true, autocomplete: "family-name"},
  birth_date: {
    required: true
    type: "date"
  }
}) +
column( "medium-6", {
  phones: { required: true, min: 1 }
  email: {
    required: true
    email: true
    check_if_email_available: true
  }
  password: {
    required: true
    min_length: 8
  }
  password_confirmation: {
    required: true
    must_equal: "password"
  }
}) +
column("medium-12", {
  personal_helpers: {
    type: "personal_helpers"
  }
})



render_cabinet_user_form = (data)->
  form_str = column("medium-6", {
    first_name: {required: true}
    middle_name: {required: true}
    last_name: {required: true},
    birth_date: {
      required: true
      type: "date"
    }
    hobby: {
      type: "text"
    }
  }, data) +
  column("medium-6", {
    phones: { required: true, min: 1 }
    email: {
      readonly: true
      help: "якщо хочете змінити email, звертайтесь до адміністратора"
    }
    password: {
      min_length: 8
      label: t("attributes.new_password")
    }
    password_confirmation: {
      must_equal: "password"
    }
    social_networks: { type: "social_networks", label: t("attributes.user_social_networks") }
    #social_facebook: {}
    #social_google_plus: {}
  }, data) +
  column("medium-12", {
    personal_helpers: {
      type: "personal_helpers"
    }
  }, data)

  save_title = t("save_profile")

  save_profile_control_str = "<div class='cabinet-profile-control cabinet-profile-control-save' title='#{save_title}'><div class='cabinet-profile-control-icon'>#{svg_images.check}</div><label class='cabinet-profile-control-label'>#{save_title}</label></div>"

  res = form_str + "<div class='cabinet-controls'>" + save_profile_control_str + "</div>"

  res


render_company_name_block = (company_name)->
  company_name = t("placeholders.name") if !company_name || !company_name.length
  "<div class='columns company-name-column'><div class='company-name'>#{company_name}</div></div>"

window.render_company_form = (data, render_controls = false)->
  data ?= {}
  company_name_str = render_company_name_block(data.name)
  window.available_industries ?= $(".cabinet-container, .registration-container").attr("data-available-industries").split(",")
  form_str = company_name_str +
  column("medium-6", {
    industry: {
      required: true
      type: "select_with_custom_value"
      select_options: window.available_industries
    }
    description: {
      type: "text"
    }
    #region: {required: true}
    regions: {
      min: 1
      type: "regions"
    }
    name: { required: true }
    position: {required: true}
    employees_count: {
      type: "integer"
      required: true
    }
  }, data) +

  column("medium-6", {
    company_site: {}
    offices: {
      type: "offices"
    }
    social_networks: { type: "social_networks" }
    #social_facebook: { type: "social", icon: "facebook" }
    #social_google_plus: { type: "social", icon: "google_plus" }


  }, data)


  add_title = t("add_company")
  remove_title = t("remove_company")
  save_title = t("save_company")
  if render_controls
    add_company_button_str = "<div class='btn company-button-add role-company-control-add' title='#{add_title}'><div class='btn-content'>#{svg_images.plus}<span class='btn-text'>#{add_title}</span></div></div>"
    save_company_control_str = "<div class='company-control company-control-save' title='#{save_title}'><div class='company-control-icon'>#{svg_images.check}</div><label class='company-control-label'>#{save_title}</label></div>"
    company_controls_str = "<div class='company-controls'><div class='company-self-controls'>#{save_company_control_str}<div class='company-control company-control-remove' title='#{remove_title}'><div class='company-control-icon'>#{svg_images.plus}</div><label class='company-control-label'>#{remove_title}</label></div></div><div class='company-controls-separator'></div><div class='new-company-controls'>#{add_company_button_str}</div></div>"
  else
    company_controls_str = ""
  "<div class='company'><div class='row'>#{form_str}</div>#{company_controls_str}</div>"

render_companies = (data)->
  s = ""


  if data && Array.isArray(data) && data.length
    for c in data
      s += render_company_form(c, true)
  else
    s = render_company_form({}, true)

  s


window.initialize_inputs = ()->
  inputs.date.initialize()
  inputs.phone.initialize()
  inputs.social.initialize()
  inputs.select_with_custom_value.initialize()

initialize_registration_forms = ()->
  return if is_cabinet
  if $("#registration-user").length
    $("#registration-user").html(registration_user_form)
  if $("#registration-companies").length
    company_forms_str = render_companies()
    #company_forms_str = render_company_form()
    $("#registration-companies").html(company_forms_str)


  initialize_inputs()




initialize_cabinet = ()->
  if is_cabinet

    try
      user_data = JSON.parse($(".cabinet-container").attr("data-user"))
    catch
      user_data = undefined

    try
      companies_data = JSON.parse($(".cabinet-container").attr("data-companies"))
    catch
      companies_data = undefined

    $("#cabinet-profile-form").html(render_cabinet_user_form(user_data))

    companies_str = render_companies(companies_data)
    $("#cabinet-companies").html(companies_str)

    initialize_inputs()



window.set_input_presence_classes = ()->
  $input_wrap = $(this)
  value = $input_wrap.find("input, textarea").val()

  empty = !value || !value.length
  add_presence_class = if empty then "empty" else "not-empty"
  remove_presence_class = if empty then "not-empty" else "empty"
  $input_wrap.changeClasses(add_presence_class, remove_presence_class)




initialize_registration_forms()
initialize_cabinet()

init_forms = (e)->
  window.is_cabinet = check_if_cabinet()
  initialize_registration_forms()
  initialize_cabinet()

init_forms()
$document.on "page:load ready", init_forms

$document.on "keyup change", "#cabinet-profile-form", ()->
  delay("put_profile", put_profile, 1000)


$document.on "keyup change", "#cabinet-companies", (e)->
  $company = $(e.target).closest(".company")
  if !$company.hasClass("has-explicitly-unsaved-changes")
    $save_button = $company.find(".company-control-save")
    #$save_button.css({display: "inline-block"})
    $save_button.css({display: "inline-block"})
    setTimeout(
      ()->
        $company.addClass("has-explicitly-unsaved-changes")
      10
    )

    setTimeout(
      ()->
        $save_button.css({display: ""})
      500

    )

  delay("put_companies", put_companies, 1000)


$document.on "keyup change", "#cabinet-profile-form", (e)->
  $form = $(this)
  if !$form.hasClass("has-explicitly-unsaved-changes")
    $save_button = $form.find(".cabinet-profile-control-save")
    #$save_button.css({display: "inline-block"})
    $save_button.css({display: "inline-block"})
    setTimeout(
      ()->
        $form.addClass("has-explicitly-unsaved-changes")
      10
    )

    setTimeout(
      ()->
        $save_button.css({display: ""})
      500

    )

  delay("put_profile", put_profile, 1000)



ajaxit = (iframe_id, form_id)->
  iFrameWindow = document.getElementById(iframe_id).contentWindow
  iFrameWindow.document.body.appendChild document.getElementById(form_id).cloneNode(true)
  frameForm = iFrameWindow.document.getElementById(form_id)
  frameForm.onsubmit = null
  frameForm.submit()
  false


$document.on "keyup", "input[name=first_name], input[name=middle_name], input[name=last_name]", (e)->
  val = $(this).val()
  capitalized = val.capitalize()
  if capitalized != val
    $(this).val(capitalized)

    $(this).trigger("keyup", e)
    $(this).trigger("change")
  true

$document.on "keyup blur change", ".input", ()->
  $input = $(this)
  if $input.filter("[validation]").length
    validate_input.call($input, true)
  else
    set_input_presence_classes.call($input)


$document.on "change", ".input-select-with-custom-value select", ()->
  if is_cabinet
    put_companies()






$document.on "keyup",
  "#cabinet-profile-form [data-key=first_name], #cabinet-profile-form [data-key=last_name]",
  ()->
    $profile_form = $(this).closest("#cabinet-profile-form")
    first_name = $profile_form.find("[data-key=first_name] input").val()
    middle_name = $profile_form.find("[data-key=last_name] input").val()
    name = "#{first_name} #{middle_name}"
    $("#cabinet-person-name").text(name)



$document.on "keyup change", "#cabinet-companies .company input[name=name]", ()->
  $input = $(this)
  company_name = $input.val()
  company_name = t("placeholders.name") if !company_name || !company_name.length
  $company = $(this).closest(".company")
  $company.find(".company-name-column .company-name").text(company_name)




update_dom_for_email_presence = (data)->
  $input_wrap = $("#registration-user .input-email")
  if data.exists
    $input_wrap.changeClasses(["invalid", "invalid-email-exists"], ["valid"])
    $error_message = $input_wrap.find(".email-exists-error-message")
    if !$error_message.length
      $input_wrap.append("<span class='email-exists-error-message'>Користувач з таким email'ом email вже існує</span>")
  else
    $input_wrap.changeClasses(["valid"], ["invalid", "invalid-email-exists"])

