filterMembers = (properties = {})->
  $members = $(this)
  $members.filter(
    ()->
      $member = $(this)

      for k, v of properties
        item_prop_values = $member.attr(k).split(",")
        return false if !item_prop_values.includes(v)

      return true
  )

$document.on "change", ".member-filter", ()->
  properties = {}
  $(".member-filter").each(
    ()->
      $select = $(this)
      value = $select.val()
      if value == "all" || value == ""
        return

      prop_name = $select.attr("data-prop-name")
      properties[prop_name] = value
  )

  has_filters = has_keys(properties)

  $members = $(".members-grid .square")

  if has_filters
    $members.filter(":not(.hide)").addClass("hide")
    $matched_members = filterMembers.call($members, properties)
    $matched_members.removeClass("hide")
  else
    $members.filter(".hide").removeClass("hide")
