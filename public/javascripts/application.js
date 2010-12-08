var ANIMATE_ELEMENT =  "<span class='loader_animate'>&nbsp;<img alt='Loading' src='/images/ajax-loader.gif'></span>"

$(function() {
  $(".article_t_p a").live("click", function() {
    //$(".pagination").html("<img src='/images/ajax-loader.gif'/>");
    $(ANIMATE_ELEMENT).insertAfter('.article_t_p');
    $.get(this.href, null, null, "script");
    return false;
  });
});

function add_animate(element_id,replace){ 
    remove_animate();
    if (replace==true) { $('#'+element_id).html(animate_element);}
    else {$(ANIMATE_ELEMENT).insertAfter('#'+element_id); }
    return false;
}

function remove_animate() {
   $('.loader_animate').remove();
   return false;
}

$(function() {
  $(".article_t a").live("click", function() {
    add_animate('catalog_items',true); 
    $.get(this.href, function(data){$('#all_content').html(data);}, null, "script");
    return false;
  });
});

function get_data(target,animation_cont,animation_cont_replace, container, on_complete) {
jQuery.ajax({beforeSend:function(request){add_animate(animation_cont,animation_cont_replace);}, complete:function(request){remove_animate();try{ if (on_complete) {return on_complete();}}catch(e){alert(e.description);}},success:function(data){$('#'+container).html(data);}, data:{}, dataType:'script', type:'get', url:target});
}

function changeImage(img_nr) {	    
   small_img_link= $('#small_img_'+img_nr).attr('src')	    
   big_img_link = $('#big_img img').attr('src');
   $('#big_img img').hide();
   add_animate('big_img');
   $('#big_img img').load(function() {
       remove_animate('big_img');
       $(this).fadeIn();
        }).attr('src',small_img_link.replace(/thumb/g, 'original'));
    $('#small_img_'+img_nr).attr('src',big_img_link.replace(/original/g, 'thumb'));
   return false;
}	 

function catalog_load_complete(){}
function product_load_complete(){}

