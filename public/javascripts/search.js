$(function() {
    $('.b-search-property a').click(function() {
        $(this).parent().find('.b-property-items').toggle();
        return false;   
     });

    $('.b-search-property :checkbox').live('click', function() {
     if ($(this).parentsUntil('.b-search-property').find('li input:checked').size() >0) {
       $(this).parentsUntil('#search_properties').find('a').addClass('has-selected-items');
     }
     else {
       $(this).parentsUntil('#search_properties').find('a').removeClass('has-selected-items');
     }     
    });               
 $('a.toggle-category').click(function(){
   $(this).next().toggle();
   return false;
  });      
});
