function bindAnimation() {
  $(".ajax_animation").bind({
      ajaxStart: function() { $(this).show(); },
      ajaxStop: function() { $(this).hide(); }
    });
}

$(function() {
  bindAnimation();

  $('.pagination-ajax a').live('click', function(e) {
    $.getScript(this.href);
   e.preventDefault();
  });

  $(".pager a").live("click", function(e) {
  	$.getScript(this.href, function(){ bindAnimation();});  
  	return false;
  });
    
    
  $("#tabs").tabs();  
});


//function add_animate(element_id,replace){ 
//    remove_animate();
//    if (replace==true) { $('#'+element_id).html(animate_element);}
//    else {$(ANIMATE_ELEMENT).insertAfter('#'+element_id); }
//    return false;
//}

//function remove_animate() {
//   $('.loader_animate').remove();
//   return false;
//}


function changeImage(img_nr) {	    
   small_img_link= $('#small_img_'+img_nr).attr('src')	    
   big_img_link = $('#big_img img').attr('src');
   $('#big_img img').hide();
//   add_animate('big_img');
   $('#big_img img').load(function() {
//       remove_animate('big_img');
       $(this).fadeIn();
        }).attr('src',small_img_link.replace(/thumb/g, 'original'));
    $('#small_img_'+img_nr).attr('src',big_img_link.replace(/original/g, 'thumb'));
   return false;
}	 

function run_scrollable() {
$("#scrollable").smoothDivScroll({ autoScroll: "onstart", autoScrollDirection: "backandforth", autoScrollStep: 1, autoScrollInterval: 15, startAtElementId: "startAtMe", visibleHotSpots: "always"});
 $("div#scrollable").bind({
      ajaxStart: function() { $(this).find('.scrolling').hide(); },
      ajaxStop: function() { $(this).find('.scrolling').show(); }
    });
return false;
}

$(function() {

  $('.scrollableArea div').mouseover(function(e) {
    $("<div style='top:"+ e.clientY + "px; left:"+ e.clientX +"px;' class='b-popup' id='popup-img'></div>")
    .html($(this).find('div').html())
    .appendTo('body')
    .fadeIn();
    $("#scrollable").smoothDivScroll("stopAutoScroll");
    
   })
  $('.scrollableArea div').mouseleave( function() {
    $("#popup-img").fadeOut().remove(); 
    $("#scrollable").smoothDivScroll("startAutoScroll");
   })
   
   
});


