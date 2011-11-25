$(function(){
    $('input').keydown(function(e){
        if (e.keyCode == 13) {
            $(this).parents('form').submit();
            return false;
        }
    });
});

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
   $('div.js-hidden').hide();
   
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
