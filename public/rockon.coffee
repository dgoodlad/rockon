paused: false

seconds_to_time: (time) ->
  minutes: Math.floor(time / 60)
  seconds: Math.floor(time - minutes * 60)
  seconds: "0$seconds" if seconds < 10
  "$minutes:$seconds"

$ ->
  $audio: $("#audio")
  audio: $audio.get(0)

  queue_next: ->
    current: $("#playlist .track.current")
    next: if current.length == 0 then $("#playlist .track").first() else current.next(".track")
    enqueue next
    current.removeClass("current")
    next.addClass("current")

  queue_prev: ->
    current: $("#playlist .track.current")
    prev: if current.length == 0 then $("#playlist .track").first() else current.prev(".track")
    enqueue prev
    current.removeClass("current")
    prev.addClass("current")

  enqueue: (track) -> $audio.attr("src", track.attr("data-path"))

  $("#play").click (event) ->
    queue_next() unless paused
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

  $("#skip").click (event) ->
    queue_next()
    audio.play()
    event.preventDefault()

  $("#prev").click (event) ->
    queue_prev()
    audio.play()
    event.preventDefault()

  $audio.bind "timeupdate", ->
    curr: seconds_to_time(audio.currentTime)
    total: seconds_to_time(audio.duration)
    $("#controls time").text "$curr / $total"

  $.ajax {
    type: 'GET',
    url: 'http://localhost:5984/rockon/_design/rockon/_view/tracks?include_docs=true&limit=25&stale=ok',
    dataType: 'jsonp',
    success: (data) ->
      $library: $("#playlist")
      data.rows.forEach (row) ->
        #console.log(row)
        path: row.doc._id.replace(/^.+\.rockon/, '')
        album: row.doc.metadata.album
        artist: row.doc.metadata.artist
        title: row.doc.metadata.title
        if artist && title
          html: """
                <div class="track" data-path="$path">
                  <span class="album">$album</span>
                  <span class="title">$title</span>
                  <span class="artist">$artist</span>
                </div>
                """
          $library.append($(html))
  }
