// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .

var api_call = function(query) {
    $.getJSON('/api?studio=' + query, function(data) {
        var name = data['studio_name'];
        var classes = data['class_list'];
        var link = data['link'];

        var class_table = $("#class_table").find('tbody');

        if (classes.length == 0) {
            // class_table.append('<tr><th>No more classes at <a href="' + link +
            //             '">' + name + '</a> today</th></tr>');
        } else {
            var header = '<tr><th><a target="_blank" href="' + link + '">' + name + '</th>' +
                         '<th>Start Time</th>' +
                         '<th>End Time</th></tr>';
            class_table.append(header);

            $.each(classes, function(index, val) {
                var row = '<tr><td>' + val['class_name'].replace('â', '-') + '</td>' +
                          '<td>' + val['start_time'] + '</td>' +
                          '<td>' + val['end_time'] + '</td></tr>';
                class_table.append(row);
            });
        }
    })
    .done(function(data) {
        $("#loading").hide();
    })
    .fail(function() {
        console.log("failed");
    });
}