function bindAnimation() {
  $(".ajax_animation").bind({
      ajaxStart: function() { $(this).show(); },
      ajaxStop: function() { $(this).hide(); }
    });
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
