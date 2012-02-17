$(function(){
    $('input').keydown(function(e){
        if (e.keyCode == 13) {
            $(this).parents('form').submit();
            return false;
        }
    });
});

$(function() {
  $('.b-who_are_you input[type="radio"]').click(function() {
    $('.b-who_are_you .info').hide('fast', function() {   });
        $(this).parent().find('.info').show('fast');    
   });
});

function changeImage(img_nr) {	    
   small_img_link= $('#small_img_'+img_nr).attr('src')	    
   big_img_link = $('#big_img img').attr('src');
   $('#big_img img').hide()
   .load(function() {
       $(this).fadeIn();
        }).attr('src',small_img_link.replace(/thumb/g, 'original'));
    $('#small_img_'+img_nr).attr('src',big_img_link.replace(/original/g, 'thumb'));
   return false;
}	 

$(function() {
  bindAnimation();
  $(".ajax-pagination a").live("click", function(e) {
  	$.getScript(this.href, function(){ bindAnimation();});  
  	return false;
  });
    
   $('a.toggle-category').bind('click', function(){
   $(this).next().toggle();
   return false;
  });      
});
