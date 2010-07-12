paused: false

$ ->
  $audio: $("#audio")
  audio: $audio.get(0)
  $("#play").click ->
    unless paused
      track: $("#playlist .track")[0]
      path: $(track).attr("data-path")
      $audio.attr('src', path)
    audio.play()

  $("#pause").click ->
    audio.pause()
    paused: true
