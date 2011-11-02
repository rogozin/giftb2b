// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.treeview
//= require base/base
//= require jquery.cookie
//= require jquery.smoothDivScroll-1.1-min
//= require search
//require_tree .

function get_cat_num(href) {
 return href.split('#')[1];
}

function set_cat_cookie(cat_num, value) {
  data =[0,0,0];
  data[cat_num] = value;
  console.log(cat_num +' '+ value);
  $.cookie('catalog_tree', data.join(""), { expires:7, path: '/' });
}

function read_cat_cookie() {
  data = $.cookie('catalog_tree');
  if (data != null && data.length > 0 ) {
    for(i=0;i<data.length;i++) {
      if (data[i]=="1") {$('#catalog_'+i).click();}
     }
   }
  return false;  
}

$(function() {
      
   
   $('.cat-name a').click(function() {
      $(this).parent().next().toggle();
      return false;
    });
    
    $('.cat-name a').toggle(function(){
      set_cat_cookie(get_cat_num(this.href),"1");
      $(this).toggleClass('b-up');     
      }, function() {
      set_cat_cookie(get_cat_num(this.href),"0");
      $(this).toggleClass('b-up');     
      }
    );
    
   read_cat_cookie(); 
    
   $('a.firm-dialog').live('click', function(e){ 
    var openMap = this.href.split('#').length ==2;    
    $.getScript(this.href, function() {       
       var map = null;        
       $("#firm_tabs").bind('tabsshow', function(event, ui) {
       if (ui.panel.id == 'map' && !map) {  
          if (la && lo) {
            map = initializeMap(la,lo,title);
            mapsize_fixed();               
          }
        }
        return false
      });
      if (openMap)  $('#firm_tabs').tabs('select',2);    
      });   
    return false;
    
    });
    
  $("#tabs").tabs();  
});


function run_scrollable() {
$("#scrollable").smoothDivScroll({ autoScroll: "onstart", autoScrollDirection: "backandforth", autoScrollStep: 1, autoScrollInterval: 15, startAtElementId: "startAtMe", visibleHotSpots: "always"});
 $("div#scrollable").bind({
      ajaxStart: function() { $(this).find('.scrolling').hide(); },
      ajaxStop: function() { $(this).find('.scrolling').show(); }
    });
  $('div.scrollable-item').mouseover(function(e) {
     $("<div style='top:"+ e.clientY + "px; left:"+ e.clientX +"px;' class='b-popup' id='popup-img'></div>")
    .html($(this).find('div').html())
    .appendTo('body')
    .fadeIn();
    $("#scrollable").smoothDivScroll("stopAutoScroll");
    
   })
  $('div.scrollable-item').mouseout( function() {
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
    return map;
  }
       
  function mapsize_fixed() {
    //document.getElementById("map").style.width = '600px';
    //document.getElementById("map").style.height = '400px';
    //google.maps.event.trigger(map, 'resize');
  }
