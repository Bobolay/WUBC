window.form_to_json = ()->
  obj = {}
  except_keys = ["offices[]", "personal_helpers[]"]
  excepted_keys = []
  $form = $(this)
  $form.find(".input").each(
    ()->
      $input = $(this)
      if $input.closest(".input-personal-helper").length
        if excepted_keys.indexOf("personal_helpers[]") < 0
          excepted_keys.push("personal_helpers[]")
        return
      if $input.closest(".input-office").length
        if excepted_keys.indexOf("offices[]") < 0
          excepted_keys.push("offices[]")
        return
      k = $input.attr("data-key")
      if k == undefined
        return

      if except_keys.indexOf(k) >= 0
        excepted_keys.push(k)
        return

      if except_keys.includes(k)
        return null
      for except_key in except_keys
        if k.startsWith(except_key + ".")
          return null

      val = $input.find("input, textarea, select").val()
      console.log "#{k}: #{val}"


      if k.endsWith("[]")
        k = k.substr(0, k.length - 2)
        obj[k] = [] if !obj[k]
        key_parts = k.split(".")
        target = obj[k]
        target.push(val)
      else
        obj[k] = val

  )

  if excepted_keys.indexOf("offices[]") >= 0
    offices = []
    $form.find(".office-inputs").map(
      ()->
        office = {}
        $office = $(this)
        office["city"] = $office.find(".input input[name='city']").val()
        office["address"] = $office.find(".input input[name='address']").val()
        office["phones"] = $office.find(".input input[name='phone']").map(
          ()->
            $(this).val()
        ).toArray()

        offices.push(office)
    )
    obj['offices'] = offices


  if excepted_keys.indexOf("personal_helpers[]") >= 0
    personal_helpers = []
    $form.find(".personal-helper-inputs").map(
      ()->
        personal_helper = {}
        $personal_helper = $(this)
        personal_helper["first_name"] = $personal_helper.find(".input input[name='first_name']").val()
        personal_helper["last_name"] = $personal_helper.find(".input input[name='last_name']").val()
        personal_helper["email"] = $personal_helper.find(".input input[name='email']").val()
        personal_helper["phones"] = $personal_helper.find(".input input[name='phone']").map(
          ()->
            $(this).val()
        ).toArray()

        personal_helpers.push(personal_helper)
    )
    obj['personal_helpers'] = personal_helpers

  obj

window.steps_to_json = ()->
  {user: form_to_json.call($("#registration-user")), company: form_to_json.call($("#registration-company")) }




window.put_profile = ()->
  data = {user: form_to_json.call($("#cabinet-profile-form"))}
  $.ajax(
    data: data
    dataType: "json"
    url: "/cabinet/profile"
    type: "post"
  )

window.put_companies = ()->
  data = {companies: []}
  $("#cabinet-companies .company").each(
    ()->
      $company = $(this)
      json = form_to_json.call($company)
      data.companies.push(json)
  )

  $.ajax(
    data: data
    dataType: "json"
    url: "/cabinet/companies"
    type: "post"
  )
