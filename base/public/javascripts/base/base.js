function bindAnimation() {
  $(".ajax_animation").bind({
      ajaxStart: function() { $(this).show(); },
      ajaxStop: function() { $(this).hide(); }
    });
}

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
  $(".pager a").live("click", function(e) {
  	$.getScript(this.href, function(){ bindAnimation();});  
  	return false;
  });
    
   $('a.toggle-category').bind('click', function(){
   $(this).next().toggle();
   return false;
  });      
});
