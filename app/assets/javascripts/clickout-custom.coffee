window.click_out_subscribers = []

get_elements = (subscriber)->

resolve_elems = (subscriber)->
  $elems = null
  if subscriber.selector
    $elems = $(subscriber.selector)
  else if subscriber.element
    $elems = $(subscriber.element)
  else if typeof subscriber.element_function == 'function'
    $elems = subscriber.element_function.call(this)



  #  if (excepted_elements = subscriber.options.except)
  #    if typeof excepted_elements == 'string'
  #      $elems = $elems.filter(
  #        (index, item)->
  #          $elem = $(this)
  #          $elem.closest(excepted_elements).length > 0
  #      )

  $elems

except_elements = (target, subscriber)->
  $elems = resolve_elems(subscriber)

  if (excepted_elements = subscriber.options.except)
    if typeof excepted_elements == 'string'
      $elems = $elems.filter(
        (index, item)->
          $elem = $(this)
          $elem.closest(excepted_elements).length > 0
      )

      $filtered_elems = $elems.filter(
        (index, item)->
          $elem = $(this)
          $elem.closest(excepted_elements).length == 0
      )

      #return $filtered_elems

      selectors_count = excepted_elements.split(",")
      i = 0


      $excepted_elements = $(excepted_elements)
      $untargeted_excepted_elements = $excepted_elements.filter(
        (index, item)->
          $elem = $(this)
          $(target).closest($elem).length > 0
      )

      return $untargeted_excepted_elements
    else if typeof excepted_elements == 'function'
      return excepted_elements.call(target, subscriber)

  else
    return []









satisfy_conditions = (subscriber)->

filter_function = (collection, subscriber, event)->
  $collection = $(this)
  $collection.filter(":visible")

$document.on "mousedown", (e)->
#console.log "CLICK"
#console.log "target:", e.target
  $target = $(e.target)
  for s in click_out_subscribers
#console.log "subscriber: ", s

#if satisfy_conditions(s)
    $elems = resolve_elems(s)

    if s.options.filter_function && (typeof s.options.filter_function == 'function' || s.options.filter_function == true)
      filter_func = s.options.filter_function

    else if s.options.filter_function == false
      filter_func = false
    else
      filter_func = false

    if filter_func
      $elems = filter_func.call($elems, $elems, s, e)
      if !$elems
        $elems = []
    #    if $elems.length > 0
    #      alert("test 1")
    $untargeted_excepted_elements = except_elements(e.target, s)
    #if $elems.length > 0

    #console.log "s: ", s, "e: ", e, "$elems:", $elems
    #console.log "elems count: ", $elems.length

    $untargeted_elems = $elems.filter(
      (index, item)->
        $elem = $(item)
        $target.closest($elem).length == 0

    )



    #console.log "$elems: ", $elems

    if $untargeted_elems.length > 0 && $untargeted_excepted_elements.length == 0
      $untargeted_elems.each (elem)->
#        if $elems.length > 0
#          alert("test 2")
        s.options.handler.call(this, s)
#s.options.handler.call(s)
#$elems.each ()->
#  s.options.handler.call(this)
#      if $elems.length > 0
#        alert("test 3")
    else
      continue



$.clickOut = (elem_or_selector_or_function, options_or_handler = {}, options = {})->
  $elem = $(elem_or_selector_or_function)

  subscriber = {}
  if typeof elem_or_selector_or_function == 'string'
    subscriber.selector = elem_or_selector_or_function
  else if typeof elem_or_selector_or_function == 'function'
    subscriber.element_function = elem_or_selector_or_function
  else
    subscriber.element = elem_or_selector_or_function

  if typeof options_or_handler == 'function'
    options['handler'] = options_or_handler

  subscriber.options = options


  click_out_subscribers.push(subscriber)
#$.clickOut()