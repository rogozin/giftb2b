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
    $('div.collapse a.up-down').toggle(function() {
      $(this).children('span').removeClass('down').addClass('up');
      $(this).parent().parent().find('.collapsible-content').toggle();
      return false;
    }, function() {
      $(this).children('span').removeClass('up').addClass('down');
      $(this).parent().parent().find('.collapsible-content').toggle();
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
