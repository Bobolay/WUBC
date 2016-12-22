$(document).ready ->

  $('.add-phone').on 'click', ->
  $(this).closest(".input-block").clone().insertAfter()
