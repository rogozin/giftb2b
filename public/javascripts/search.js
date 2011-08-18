$(function() {
    $('.b-search-property a').click(function() {
        $(this).parent().find('.b-property-items').toggle();
        return false;   
     });

    $('.b-search-property :checkbox').live('click', function() {
     if ($(this).parent().parent().find('li input:checked').size() >0) {
       console.log(       $(this).parentsUntil('#search_properties').find('a'));
       $(this).parentsUntil('#search_properties').find('a').addClass('has-selected-items');
     }
     else {
       $(this).parentsUntil('#search_properties').find('a').removeClass('has-selected-items');
     }     
    }); 
});
