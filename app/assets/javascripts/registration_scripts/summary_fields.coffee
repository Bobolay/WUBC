window.summary_field_types = {
  string: {
    render: (name, value, options = {})->
      if !value || !value.length
        return ""
      field_name = t("summary_labels.#{name}") || t("attributes.#{name}") || name
      field_value = value
      type = options.type || "string"

      "<div class='field #{type} field-#{name}'><div class='field-name'>#{field_name}</div><div class='field-value'>#{field_value}</div></div>"
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
      field_name = t("attributes.#{name}") || name
      field_value = value
      formatted_value = "<a href='#{field_value}'>#{field_value}</a>"
      "<div class='field #{options.type} field-#{name}'><div class='field-name'>#{field_name}</div><div class='field-value'>#{formatted_value}</div></div>"
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