window.delays = {}
window.last_calls = {}
window.delay = (key, callback, timeout = 1000, call_right_now = false, run_callbacks_later = true)->
  if delays[key]
    clearTimeout(delays[key])
  if call_right_now
    last_call = last_calls[key]
    current_time = Date.now()
    allow_call = !last_call || current_time - last_call >= timeout
    if allow_call
      last_calls[key] = current_time
      callback()
  if run_callbacks_later
    delays[key] = setTimeout(callback, timeout)



