function get_cat_num(href) {
 return href.split('#')[1];
}

function set_cat_cookie(cat_num, value) {
  data =[0,0,0];
  data[cat_num] = value;
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
  $(".ajax_animation")
  .on("ajaxStart", function() { $(this).show(); }) 
  .on("ajaxStop", function() { $(this).hide(); });
}

$(function() {
   $('.b-tree').treeview({collapsed: true,persist: "cookie"});  
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
  return false;
})

