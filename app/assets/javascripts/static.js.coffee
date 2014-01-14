# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#click-test').click ->
    # $('<div />').html('hello there').dialog();
    newDiv = $(document.createElement('div'))
    newDiv.html "<p>hello there</p>"
    newDiv.dialog
      closeOnEscape: true
      buttons: [
        text: "Ok"
        click: ->
          $(this).dialog "close"
      ]
    console.log("done!")
    false