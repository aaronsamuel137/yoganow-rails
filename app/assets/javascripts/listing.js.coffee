# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@api_call = (query, num_classes, start_time) ->
  $.getJSON('/api?studio=' + query + '&num_classes=' + num_classes + '&start_time=' + start_time, (data) ->
    name = data['studio_name']
    classes = data['class_list']
    link = data['link']

    class_table = $('#class_table').find('tbody')
    id_num = 1
    unless classes.length is 0
      header = '<tr><th class="col-sm-8"><a target="_blank" href="' + link + '">' + name + '</th>' + '<th>Start Time</th>' + '<th>End Time</th></tr>'
      class_table.append header

      $.each classes, (index, val) ->
        id = name.replace(/\s/g, '') + id_num
        row = '<tr><td><a id="' + id + '" href="javaScript:void(0);">' + val['class_name'] + '</a></td><td>' + val['start_time'] + '</td><td>' + val['end_time'] + '</td></tr>'
        class_table.append row
        windowHeight = $(window).height();
        dialogHeight = windowHeight * 0.5;
        windowWidth = $(window).width();
        dialogWidth = windowWidth * 0.4;

        if val['description']
          console.log("loaded data for #{val['class_name']} with id #{id}!")

          $('#' + id).click ->
            newDiv = $(document.createElement('div'))
            newDiv.html "<p>#{val['description']}</p>"
            newDiv.addClass "description-popup"
            newDiv.dialog
              closeOnEscape: true
              title: val['class_name']
              maxHeight: dialogHeight
              width: dialogWidth
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
