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
