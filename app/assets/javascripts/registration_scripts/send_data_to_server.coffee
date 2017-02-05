window.form_to_json = ()->
  obj = {}
  except_keys = ["offices[]"]
  $form = $(this)
  $form.find(".input").map(
    ()->
      $input = $(this)

      k = $input.attr("data-key")
      if k == undefined
        return

      if except_keys.includes(k)
        return null
      for except_key in except_keys
        if k.startsWith(except_key + ".")
          return null

      val = $input.find("input, textarea, select").val()


      if k.endsWith("[]")
        k = k.substr(0, k.length - 2)
        obj[k] = [] if !obj[k]
        key_parts = k.split(".")
        target = obj[k]
        target.push(val)
      else
        obj[k] = val

  )

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
