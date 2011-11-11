//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require ui.datepicker-ru
//= require_tree .
// require jquery.form
//= require_self
//= require tinymce-jquery
//= require admin/tinymce_init

$(function() {
   $('a.toggle-category').bind('click', function(){
   $(this).next().toggle();
   return false;
  });      
});

function processing_in_progress() {
  $('#cancel').show(); 
  setInterval(function(){$('#progress').load('/admin/data_changes/get_status');}, 3000);
  return false;
}

