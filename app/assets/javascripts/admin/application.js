//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require ui.datepicker-ru
//= require wymeditor/jquery.wymeditor.min
//= require_tree .
//= require jquery.form



$(function() {
   $('a.toggle-category').bind('click', function(){
   $(this).next().toggle();
   return false;
  });      
});
