
$document.on "click", ".regions .inputs-collection-control", ()->
  $button = $(this)
  action = if $button.hasClass("inputs-collection-control-add") then 'add' else 'remove'
  $inputs_collection = $button.closest(".inputs-collection")
  $inputs_collection_inputs = $inputs_collection.find(".inputs-collection-inputs")
  $inputs_collection_inputs_children = $inputs_collection_inputs.children()

  input_type = "string"
  input_options = {key: "regions[]"}
  input_name = "region"

  if action == "add"
    input_str = inputs[input_type].render(input_name, input_options)
    $inputs_collection_inputs.append(input_str)
    inputs[input_type].initialize() if inputs[input_type] && inputs[input_type].initialize
  else
    $inputs_collection_inputs_children.last().remove()


  if $inputs_collection_inputs.children().length > 1
    $inputs_collection.removeClass("inputs-collection-single-input")
  else
    $inputs_collection.addClass("inputs-collection-single-input")

  put_companies() if is_cabinet




