$(function() {
 $('a.toggle-category').live('click', function(){
   $(this).next().toggle();
   return false;
  });  
  $("#select_category").live('click', function() {
    $("#categories_dialog").dialog({ 
        buttons: { "Ok": function() { $(this).dialog("close");} },
        close: function(event, ui) { 
          $('#category_ids').empty();
          arr = [];
          dialog = this;
          $(dialog).find(':checked').each(function(index){ 
            arr[index] = $(dialog).find('label[for="'+this.id+'"]').text();
            $("<input type='hidden' name='category_ids[]' value='" + this.value + "'>").appendTo('#category_ids'); 
           });
          $("#select_category").text(arr.join(', ')); 
         }                                             
     });
    return false;
    });
});
