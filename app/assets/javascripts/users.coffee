$(document).on 'ready', ->
  $('#main-navbar form').submit (event) ->
    event.preventDefault()
    window.location.href = "/u/#{$.trim($(this).find('input').val())}"
