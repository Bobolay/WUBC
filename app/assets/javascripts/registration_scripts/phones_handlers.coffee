
$document.on "click", ".phones .inputs-collection-control", ()->
  $button = $(this)
  action = if $button.hasClass("inputs-collection-control-add") then 'add' else 'remove'
  $inputs_collection = $button.closest(".inputs-collection")
  $inputs_collection_inputs = $inputs_collection.find(".inputs-collection-inputs")
  $inputs_collection_inputs_children = $inputs_collection_inputs.children()

  if action == "add"
    input_str = inputs.phone.render("phone", {key: "phones[]"})
    $inputs_collection_inputs.append(input_str)
    inputs.phone.initialize()
  else
    $inputs_collection_inputs_children.last().remove()


  if $inputs_collection_inputs.children().length > 1
    $inputs_collection.removeClass("inputs-collection-single-input")
  else
    $inputs_collection.addClass("inputs-collection-single-input")

  put_profile() if is_cabinet




