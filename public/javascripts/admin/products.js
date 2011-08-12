$(document).ready(function() {
  $('#select_all_chb').bind('click', function() {$("input[type='checkbox']").attr('checked', 'checked') });
  $('#select_all_chb').bind('dblclick', function() {$("input[type='checkbox']").removeAttr('checked') });


  function clear_group_form() {
    $('#commit').hide();
    $('#category_id').remove();
    $('#property_name').remove();
    $('#property_value').remove();
    return false;
  }


  $('#oper').bind('change', function() {
  switch(this.value) {
    case 'delete':
      clear_group_form();
      $('#commit').show();
      $(this).parent().append('');
      break;
    case 'copy':
      clear_group_form();
      $('#category').clone().attr('id','category_id').insertAfter('#oper');
      $('#commit').show();
      break;
    case 'change':
      clear_group_form();
      $('#oper').after("<select id='property_name' name='property_name'>"+
      "<option value='null'><-Выберите свойство-></option>"+
      "<option value='color'>Цвет(П)</option>"+
      "<option value='factur'>Материал(П)</option>"+
      "<option value='box'>Упаковка</option>"+
      "<option value='size'>Размер</option>"+
      "<option value='is_new'>Новинка</option>"+
      "<option value='is_sale'>Распродажа</option>"+
      "<option value='best_price'>Отличная цена</option>"+
      "<option value='sort_order'>Сортировка</option>"+
      "<option value='additional_props'>Дополнительные свойства</option>"+
      "</select>");
      $('#commit').show();
      break;      
    default:
      clear_group_form();
    }
  });
  
  $('.group-ops form').bind('submit', function() {
    $('#product_ids').val($.map($("#products_list input:checked"), function(n){return n.value }).join(','));
  });

  $('#property_name').live('change', function() {
  $('#property_value').remove();
  if (this.value != "null") {
    if (this.value == 'color' || this.value == 'factur' || this.value == 'box' || this.value == 'size' || this.value == 'sort_order') {
      $(this).after("<input id='property_value' name='property_value' type='text'>");
    }
    if ((this.value == 'is_new') || (this.value == 'is_sale') || (this.value == 'best_price')) {
      $(this).after("<select id='property_value' name='property_value'>" +
      "<option value='0'>Нет</option>" +
      "<option value='1'>Да</option>" +
      "</select>");
    }        
    if (this.value == 'additional_props') {
      $('#group_property_id').show();      
    }
  }
  else {
    $('#group_property_id').hide(); 
    }
  });
  
  
  $('#group_property_id').change(function() {
    if (this.value > -1) {
      $('#group_property_values').html("<div id='group_property_" + this.value + "'>Выберите значение:<div class='filter-property-values'></div></div>");
      $.getScript('/admin/properties/' + this.value + '/load_filter_values?check_box_name=property_values[]&prefix=group');
    }
  });

  
  
   $('.ajax-load :checkbox').live('click', function() {
    if ($(this).parent().parent().find('li input:checked').size() >0) {
       $(this).parentsUntil('.ext-search').find('a').addClass('has-selected-items');
     }
     else {
       $(this).parentsUntil('.ext-search').find('a').removeClass('has-selected-items');
     }     
  });
  
  $('.ajax-load a.pseudo-link').toggle( 
    function() { 
      if ($(this).parent().find('.filter-property-values ul').size() == 0) {
         $.get(this.href);
         $(this).parent().find('.filter-property-values').show();
        }
      else {
         $(this).parent().find('.filter-property-values').show();
        }},
    function() { $(this).parent().find('.filter-property-values').hide();}
  );
  
 

})
