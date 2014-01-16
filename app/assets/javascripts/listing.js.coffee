# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

writeTable = (data, num_classes, start_time) ->
  console.log "writing table"
  for studio in data
    name = studio['studio_name']
    classes = studio['class_list']
    link = studio['link']

    if start_time == -1
      start_time = new Date()
      console.log start_time

    class_table = $('#class_table').find('tbody')
    id_num = 1
    unless classes.length is 0
      header = '<tr><th class="col-sm-8"><a target="_blank" href="' + link + '">' + name + '</th>' + '<th>Start Time</th>' + '<th>End Time</th></tr>'
      class_table.append header

      num_written = 0
      $.each classes, (index, val) ->
        timeArray = val['start_time'].trim().split(/[:\s]+/)
        console.log timeArray[0]
        hour = if timeArray[2] == 'PM' and timeArray[0] != '12' then parseInt(timeArray[0]) + 12 else timeArray[0]
        now = new Date(start_time.getFullYear(), start_time.getMonth(), start_time.getDate(), hour, timeArray[1])
        console.log now
        console.log hour

        if now >= start_time
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
          if num_written >= num_classes
            return false

        id_num += 1

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
  $('#location-div').append "<br>Closest studio is #{studio}"

handleError = ->
  console.log "Error getting position"

createDB = ->
  console.log "in createDB"
  request = indexedDB.open("schedules")

  request.onupgradeneeded = ->
    console.log "In onupgradeneeded"
    db = request.result
    store = db.createObjectStore("classes",
      keyPath: "key"
    )
    titleIndex = store.createIndex("by_name", "name")
    dateIndex = store.createIndex("by_date", "date")

  request.onsuccess = ->
    console.log "In onsuccess"
    db = request.result
    cursorData = []

    today = new Date().getDate()
    if localStorage.dateStored == undefined || today != parseInt(localStorage.dateStored)
      localStorage.dateStored = today
      getdata(db)
    else
      transaction = db.transaction("classes")
      store = transaction.objectStore("classes");
      cursorRequest = store.openCursor()

      cursorRequest.onsuccess = (event) ->
        cursor = event.target.result
        if cursor
          cursorData.push(cursor.value)
          cursor.continue()
        else
          console.log("No more entries!")

      transaction.oncomplete = ->
        writeTable(cursorData, 3, -1)


getdata = (db) ->
  $.getJSON('/api', (data) ->
    tx = db.transaction("classes", "readwrite")
    store = tx.objectStore("classes")

    for studio in data
      studio.key = studio.studio_name.replace(/\s/g, '')
      store.put studio

    writeTable(data, 3, -1)

    tx.oncomplete = ->
      console.log "complete!"

  ).done((data) ->
    console.log "done loading json"
  ).fail( ->
    console.log "failed loading json"
  )

$(document).ready ->
  console.log "document ready"
  createDB()
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition showPosition, handleError
  else
    console.log "Geolocation is not supported by this browser."
