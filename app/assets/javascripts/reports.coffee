# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.new_report').validate()
$(document).ready ->
  $('.datecker').datepicker()
  $('.state_selection').on "change", ->
    $.ajax
      url: "/locations_for_state"
      type: "GET"
      dataType: "script"
      data:
        state_short_code: $('.state_selection option:selected').val()
      beforeSend: () ->
        $('#report_location_id').prop('disabled', 'disabled')
        $('.field_label').text("Updaing locations...")
      success: () ->
        $('#report_location_id').removeProp('disabled')
        $('.field_label').html('<label for="report_location_id">Location</label> (Required)')
