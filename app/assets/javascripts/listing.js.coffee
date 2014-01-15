# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@api_call = (num_classes, start_time) ->
  $.getJSON('/api?num_classes=' + num_classes + '&start_time=' + start_time, (data) ->
    for studio in data
      name = studio['studio_name']
      classes = studio['class_list']
      link = studio['link']

      class_table = $('#class_table').find('tbody')
      id_num = 1
      unless classes.length is 0
        header = '<tr><th class="col-sm-8"><a target="_blank" href="' + link + '">' + name + '</th>' + '<th>Start Time</th>' + '<th>End Time</th></tr>'
        class_table.append header

        $.each classes, (index, val) ->
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

          else
            console.log("no data for #{val['class_name']}")

          id_num += 1

    ).done((data) ->
      $('#loading').hide()
    ).fail ->
      console.log 'failed'

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

$(document).ready ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition showPosition, handleError
  else
    console.log "Geolocation is not supported by this browser."
