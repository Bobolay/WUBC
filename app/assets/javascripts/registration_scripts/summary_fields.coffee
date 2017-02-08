window.summary_field_types = {
  base: {
    get_field_name: (attr_name, options = {})->
      s = t("summary_labels.#{attr_name}") || t("attributes.#{attr_name}") || attr_name
      s + ":"
  }
  string: {
    render: (name, value, options = {})->
      if !value || !value.length
        return ""
      field_name = summary_field_types.base.get_field_name(name, options)
      field_value = value
      type = options.type || "string"

      "<div class='field #{type} field-#{name}'><div class='field-name'>#{field_name}</div><div class='field-value'>#{field_value}</div></div>"
  }

  regions: {
    render: (name, value, options = {})->
      options.type ?= "regions"
      if !value || !value.length
        return ""
      str = value.join(", ")
      summary_field_types.string.render(name, str, options)
  }

  phones: {
    render: (name, value, options = {})->
      options.type ?= "phones"
      str = value.join("<br/>")
      summary_field_types.string.render(name, str, options)
  }

  site: {
    render: (name, value, options = {})->
      options.type ?= "site"
      if !value || !value.length
        return ""
      field_name = summary_field_types.base.get_field_name(name, options)
      field_value = value
      formatted_value = "<a href='#{field_value}'>#{field_value}</a>"
      "<div class='field #{options.type} field-#{name}'><div class='field-name'>#{field_name}</div><div class='field-value'>#{formatted_value}</div></div>"
  }

  personal_helpers: {
    render: (name, value, options = {})->
      personal_helpers_collection = value
      personal_helpers_str = ""
      personal_helpers = personal_helpers_collection.map(
        (personal_helper)->
          phones_str = ""
          phones = personal_helper.phones.filter(
            (phone)->
              phone && phone.length > 0
          ).map(
            (phone)->
              "<div>#{phone}</div>"
          )
          if phones.length
            phones_str = phones.join("")


          "#{personal_helper.first_name} #{personal_helper.last_name}#{if phones_str.length then '<br/>' + phones_str else '' }#{if personal_helper.email && personal_helper.email.length then '<div>' + personal_helper.email + '</div>' else ''}"
      ).filter(
        (personal_helper_str)->
          personal_helper_str.length > 0
      ).map(
        (personal_helper_str)->
          "<div class='summary-field-personal-helper'>#{personal_helper_str}</div>"
      )

      personal_helpers_str = personal_helpers.join("")

      options.type ?= "personal_helpers"


      summary_field_types.string.render(name, personal_helpers_str, options)
  }

  offices: {
    render: (name, value, options = {})->
      offices_collection = value
      offices_str = ""
      offices = offices_collection.map(
        (office)->
          phones_str = ""
          phones = office.phones.filter(
            (phone)->
              phone && phone.length > 0
          ).map(
            (phone)->
              "<span>#{phone}</span>"
          )
          if phones.length
            phones_str = phones.join(", ")


          "м. #{office.city}, #{office.address}#{if phones_str.length then '<br/>' + phones_str else '' }"
      ).filter(
        (office_str)->
          office_str.length > 0
      ).map(
        (office_str)->
          "<p>#{office_str}</p>"
      )

      offices_str = offices.join("")

      options.type ?= "offices"


      summary_field_types.string.render(name, offices_str, options)
  }
  social: {
    render: (name, value, options = {})->
      if !value || !value.length
        return ""
      options.type ?= "social"
      icon_str = svg_images[name]
      url = value
      social_str = "<a href='#{url}' class='social-icon popup-window-link' target='_blank'>#{icon_str}</a>"
      summary_field_types.string.render(name, social_str, options)
  }

}