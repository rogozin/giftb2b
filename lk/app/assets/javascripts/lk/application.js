//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require effects
//= require jquery.treeview
//= require jquery.cookie
//= require layout
//= require tinymce-jquery
//= require_tree .
//= require search
//= require bootstrap-transition
//= require bootstrap-alert
//= require bootstrap-modal
//= require bootstrap-dropdown
//= require bootstrap-scrollspy
//= require bootstrap-tab
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require bootstrap-button
//= require bootstrap-collapse
//= require bootstrap-carousel
//= require bootstrap-typeahead


  /* Update datepicker plugin so that MM/DD/YYYY format is used. */
      $.extend($.fn.datepicker.defaults, {
        parse: function (string) {
          var matches;
          if ((matches = string.match(/^(\d{2,2})\.(\d{2,2})\.(\d{4,4})$/))) {
            console.log(matches);
            return new Date(matches[3], matches[2]-1, matches[1]);
          } else {
            return null;
          }
        },
        format: function (date) {
          var
            month = (date.getMonth() + 1).toString(),
            dom = date.getDate().toString();
          if (month.length === 1) {
            month = "0" + month;
          }
          if (dom.length === 1) {
            dom = "0" + dom;
          }
          return dom + "." + month + "." + date.getFullYear();
        }
      });  


$(function() {
 $(".collapse").collapse();
// $("#close_dialog").live('click', function(){ $(this).parents('form').dialog("close") });
 $('a.toggle-category').live('click', function(){
   $(this).next().toggle();
   return false;
  });  
  $(".ajax-pagination a").live("click", function(e) {
  	$.getScript(this.href, function(){ bindAnimation();});  
  	return false;
  });       
});
