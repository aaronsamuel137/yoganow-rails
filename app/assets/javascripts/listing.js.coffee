# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

writeTable = (data, numClasses, startTime) ->
  # if numClasses or startTime is null, grab it from local storage
  if numClasses == null
    numClasses = parseInt(sessionStorage.numClasses)
  else
    numClasses = parseInt(numClasses)
    sessionStorage.numClasses = numClasses
  if startTime == null
    startTime = parseInt(sessionStorage.startTime)
  else
    startTime = parseInt(startTime)
    sessionStorage.startTime = startTime

  # set start to be a Date object indicating the desired start time
  currentTime = new Date()
  if startTime == -1
    start = currentTime
  else
    start = new Date(currentTime.getFullYear(), currentTime.getMonth(), currentTime.getDate(), startTime)

  class_table = $('#class_table').find('tbody')
  class_table.empty()

  for studio in data
    name = studio['studio_name']
    classes = studio['class_list']
    link = studio['link']
    id_num = 1

    unless classes.length is 0
      header = '<tr><th class="col-sm-8"><a target="_blank" href="' + link + '">' + name + '</th>' + '<th>Start Time</th>' + '<th>End Time</th></tr>'
      headerAdded = false

      num_written = 0
      $.each classes, (index, val) ->
        timeArray = val['start_time'].trim().split(/[:\s]+/)
        hour = parseInt(timeArray[0])
        if timeArray[2] == 'PM' and timeArray[0] != '12'
          hour += 12
        classTime = new Date(currentTime.getFullYear(), currentTime.getMonth(), currentTime.getDate(), hour, timeArray[1])

        if classTime >= start
          if !headerAdded
            headerAdded = true
            class_table.append header

          id = name.replace(/\s/g, '') + id_num
          row = '<tr><td><a id="' + id + '" href="javaScript:void(0);">' + val['class_name'] + '</a></td><td>' + val['start_time'] + '</td><td>' + val['end_time'] + '</td></tr>'
          class_table.append row

          if val['description']
            $('#' + id).click ->
              mq = window.matchMedia( "(min-width: 500px)" )
              if mq.matches
                windowHeight = $(window).height()
                dialogHeight = windowHeight * 0.2
                windowWidth = $(window).width()
                dialogWidth = windowWidth * 0.4
              else
                windowHeight = $(window).height()
                windowWidth = $(window).width()

              newDiv = $(document.createElement('div'))
              newDiv.html "<p>#{val['description']}</p>"
              newDiv.addClass "description-popup"
              newDiv.dialog
                minHeight: dialogHeight
                minWidth: dialogWidth
                closeOnEscape: true
                title: val['class_name']
                modal: true
                buttons: [
                  text: "Ok"
                  click: ->
                    $(this).dialog "close"
                ]
              false

          num_written += 1
          if numClasses != -1 and num_written >= numClasses
            return false

        id_num += 1

  if startTime == -1
    timeStr = 'NOW'
  else
    hour = start.getHours()
    if hour > 12
      hour -= 12
      amPm = 'PM'
    else
      amPm = 'AM'
    timeStr = 'at ' + hour + ':00 ' + amPm

  switch numClasses
    when 1
      numStr = 'one class'
    when -1
      numStr = 'all remaining'
    else
      numStr = numClasses + ' classes'

  $('#info-div').html("Displaying #{numStr} from each studio, starting #{timeStr}")
  $('#loading').hide()

showPosition = (position) ->
  lat = position.coords.latitude
  lng = position.coords.longitude

  lowest = Infinity
  for loc in gon.locations
    distance = Math.pow(lat - loc.lat, 2) + Math.pow(lng - loc.lng, 2)
    if distance < lowest
      lowest = distance
      studio = loc.name
  $('#location-div').append "Closest studio is #{studio}"

handleError = ->
  console.log "Error getting position"

@getOrLoadData = (numClasses, start_time) ->
  request = indexedDB.open("schedules")

  request.onupgradeneeded = ->
    db = request.result
    store = db.createObjectStore("classes",
      keyPath: "key"
    )

  request.onsuccess = ->
    db = request.result
    cursorData = []

    today = new Date().getDate()
    if localStorage.dateStored == undefined || today != parseInt(localStorage.dateStored)
      localStorage.dateStored = today
      getdata(db, numClasses, start_time)
    else
      transaction = db.transaction("classes")
      store = transaction.objectStore("classes");
      cursorRequest = store.openCursor()

      cursorRequest.onsuccess = (event) ->
        cursor = event.target.result
        if cursor
          cursorData.push(cursor.value)
          cursor.continue()

      transaction.oncomplete = ->
        writeTable(cursorData, numClasses, start_time)


getdata = (db, numClasses, start_time) ->
  $.getJSON('/api', (data) ->
    tx = db.transaction("classes", "readwrite")
    store = tx.objectStore("classes")

    for studio in data
      studio.key = studio.studio_name.replace(/\s/g, '')
      store.put studio

    writeTable(data, numClasses, start_time)

    tx.oncomplete = ->
      console.log "complete!"

  ).done((data) ->
    console.log "done loading json"
  ).fail( ->
    console.log "failed loading json"
  )

@ready = ->
  if !sessionStorage.numClasses
    sessionStorage.numClasses = 3
  if !sessionStorage.startTime
    sessionStorage.startTime = -1

  getOrLoadData(sessionStorage.numClasses, sessionStorage.startTime)

  # UNCOMMENT THIS SECTION TO TURN ON LOCATING CLOSEST STUDIO
  # if navigator.geolocation
  #   navigator.geolocation.getCurrentPosition showPosition, handleError
  # else
  #   console.log "Geolocation is not supported by this browser."
