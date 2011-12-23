//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery-ui
//= require jquery.treeview
//= require jquery.cookie
//= require layout
//= require ui.datepicker-ru
//= require tinymce-jquery
//= require_tree .
//= require search

$(function() {
 $("#tabs").tabs();  
 $("#close_dialog").live('click', function(){ $(this).parents('form').dialog("close") });
 $('a.toggle-category').live('click', function(){
   $(this).next().toggle();
   return false;
  });  
  $("#select_category").live('click', function() {
    $("#categories_dialog").dialog({ 
        buttons: {"Очистить": function(){$(this).find(":checked").attr('checked', false);} , "Ok": function() { $(this).dialog("close");} },
        close: function(event, ui) { 
          $('#category_ids').empty();          
          setValues(this);
         }                                             
     });
    return false;
    });

  $(".pager a").live("click", function(e) {
  	$.getScript(this.href, function(){ bindAnimation();});  
  	return false;
  });
        
});

function setValues(dialog) {
          arr = [];
          $(dialog).find(':checked').each(function(index){ 
            arr[index] = $(dialog).find('label[for="'+this.id+'"]').text();
            $("<input type='hidden' name='category_ids[]' value='" + this.value + "'>").appendTo('#category_ids'); 
           });
          $("#select_category").text( arr.length == 0 ? "Искать в разделах" : arr.join(', ')); 
          return false;
}         


