# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@api_call = (query, num_classes, start_time) ->
  $.getJSON('/api?studio=' + query + '&num_classes=' + num_classes + '&start_time=' + start_time, (data) ->
    name = data['studio_name']
    classes = data['class_list']
    link = data['link']
    class_table = $('#class_table').find('tbody')
    unless classes.length is 0
      header = '<tr><th><a target="_blank" href="' + link + '">' + name + '</th>' + '<th>Start Time</th>' + '<th>End Time</th></tr>'
      class_table.append header
      $.each classes, (index, val) ->
        row = '<tr><td>' + val['class_name'].replace('â', '-') + '</td>' + '<td>' + val['start_time'] + '</td>' + '<td>' + val['end_time'] + '</td></tr>'
        class_table.append row

  ).done((data) ->
    $('#loading').hide()
  ).fail ->
    console.log 'failed'
