window.keys = (hash)->
  keys = []
  for k, v of hash
    keys.push(k)

  keys

window.has_keys = (hash)->
  keys(hash).length > 0