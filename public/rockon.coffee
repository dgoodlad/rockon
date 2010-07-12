paused: false

seconds_to_time: (time) ->
  minutes: Math.floor(time / 60)
  seconds: Math.floor(time - minutes * 60)
  seconds: "0$seconds" if seconds < 10
  "$minutes:$seconds"

$ ->
  $audio: $("#audio")
  audio: $audio.get(0)
  $("#play").click (event) ->
    unless paused
      track: $("#playlist .track")[0]
      path: $(track).attr("data-path")
      $audio.attr('src', path)
    audio.play()
    event.preventDefault()

  $("#pause").click (event) ->
    audio.pause()
    paused: true
    event.preventDefault()

  $("#stop").click (event) ->
    # The audio dom interface doesn't support a stop() function
    # We'll simulate it by pausing
    audio.pause()
    paused: false
    event.preventDefault()

  $audio.bind "timeupdate", ->
    curr: seconds_to_time(audio.currentTime)
    total: seconds_to_time(audio.duration)
    $("#controls time").text "$curr / $total"

