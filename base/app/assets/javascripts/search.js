function selectColor(selector) {
  $(selector).addClass('shadow'); 
  $('#color_ids').append('<input type="hidden" value=' + selector.id.match(/\d+/)[0] + ' name="pv_' + cp_id + '[]">');
  return false;
}

function removeColor(selector) {
  $(selector).removeClass('shadow');
  $('#color_ids input[value="' + selector.id.match(/\d+/)[0] + '"]').remove(); 
  return false;
}

$(function() {
    $('div.collapse a.up-down-text').click(function() {
        if ($(this).text() == "Развернуть") {
           $(this).text("Свернуть");
           $(this).next().click();
        }
        else {
           $(this).text("Развернуть");
           $(this).next().click();        
        }        
        return false;
        
    });

    $('div.collapse a.up-down').click(function() {
      if ($(this).children('span').hasClass('down')) {
          $(this).attr('title', "Свернуть");
          $(this).children('span').removeClass('down').addClass('up');
          $(this).parents('form').find('.line').hide();
          $(this).parent().parent().find('.collapsible-content:first').toggle('fast');
        }
      else {
          $(this).attr('title', "Развернуть");
          $(this).children('span').removeClass('up').addClass('down');
          $(this).parent().parent().find('.collapsible-content:first').toggle('fast', function() {
            $(this).parents('form').find('.line').fadeIn();          
            }
          );
        }
      return false;
    });
    
    cp_id  = $('#color_ids').attr('title');
    $('#ext_search .color-box').click(function() { 
        if ($(this).hasClass('shadow')) 
          removeColor(this); 
        else 
          selectColor(this); 
      });

    $('.b-search-property :checkbox').live('click', function() {
     if ($(this).parentsUntil('.b-search-property').find('li input:checked').size() >0) {
       $(this).parentsUntil('#search_properties').find('a').addClass('has-selected-items');
     }
     else {
       $(this).parentsUntil('#search_properties').find('a').removeClass('has-selected-items');
     }     
    });               
});
