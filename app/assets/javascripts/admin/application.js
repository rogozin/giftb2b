//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require ui.datepicker-ru
//= require_tree .
// require jquery.form
//= require_self
//= require tinymce-jquery
//= require admin/tinymce_init

function processing_in_progress() {
  $('#cancel').show(); 
  setInterval(function(){$('#progress').load('/admin/data_changes/get_status');}, 3000);
  return false;
}

function bindAnimation() {
  $(".ajax_animation").bind({
      ajaxStart: function() { $(this).show(); },
      ajaxStop: function() { $(this).hide(); }
    });
}


$(function() {
   $('a.toggle-category').bind('click', function(){
   $(this).next().toggle();
   return false;
  });      
  bindAnimation();
  $(".pager a").live("click", function(e) {
  	$.getScript(this.href, function(){ bindAnimation();});  
  	return false;
  });  
  
});



