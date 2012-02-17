window.setCateogryFilterValues = (dialog) ->  
  arr = []
  $(dialog).find(':checked').each (index) -> 
    arr[index] = $(dialog).find("label[for='#{this.id}']").text()
    $("<input type='hidden' name='category_ids[]' value='#{this.value}'>").appendTo('#category_ids'); 
  if arr.length == 0 
    $("#select_category").text "Отфильтровать по категории товара"
    $('#category_ids').html "<input type='hidden' name='category_ids[]'>"
  else
     $("#select_category").text arr.join(', ')       

jQuery -> 
  $('#clear_tree').on 'click', ->
    $('#categories_dialog :checked').attr 'checked', false
    false
    
  $('#categories_dialog').live 'hide', -> 
    setCateogryFilterValues(this)
