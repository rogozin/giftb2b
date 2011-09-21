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
    
   $('a.toggle-category').bind('click', function(){
   $(this).next().toggle();
   return false;
  });      
    
   $('a.firm-dialog').bind('click', function(){ 
    $.getScript(this.href, function() {       
       $("#firm_tabs").bind('tabscreate', function(event, ui) {
       });
        
       var map = null; 
       $("#firm_tabs").bind('tabsshow', function(event, ui) {
       if (ui.panel.id == 'map' && !map) {  
          if (la && lo) {
            map = initializeMap(la,lo,title);
            mapsize_fixed();   
          }
          }
      });

      });
    return false;
    });
    
  $("#tabs").tabs();  
});

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
return false;
}

  function initializeMap(la, lo, title) {
    var myLatlng = new google.maps.LatLng(la, lo);
    var myOptions = {
        zoom: 16,
        center: myLatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
       }
     var map =  new google.maps.Map(document.getElementById("map"), myOptions);
     var marker = new google.maps.Marker({
       position: myLatlng, 
       map: map, 
       title: title
      });   
    return map
  }
       
  function mapsize_fixed() {
    document.getElementById("map").style.width = '600px';
    document.getElementById("map").style.height = '400px';
    google.maps.event.trigger(map, 'resize');
  }
