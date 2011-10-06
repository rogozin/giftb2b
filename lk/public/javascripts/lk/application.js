// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
function bindAnimation() {
  $(".ajax_animation").bind({
      ajaxStart: function() { $(this).show(); },
      ajaxStop: function() { $(this).hide(); }
    });
}

$(function() {
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
          $("#select_category").text( arr.length == 0 ? "Выберите категорию товара" : arr.join(', ')); 
          return false;
}         


