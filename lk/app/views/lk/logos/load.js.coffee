$("#logo_stack").html '<img src="<%=@src %>" alt="<%= @file_name %>" />'
$(".logo_transform_modal #logo").empty()
$('.logo_transform_modal #logo').data 'logo-url', "<%= @src %>"
tr = $('.logo_transform_modal #logo').logoTransform({
    onsave: -> 
      console.log "dlg save..."      
      console.log "update #{<%= dom_id(@item) %>}"
      $("#<%= dom_id(@item) %>").replaceWith("<%= escape_javascript render(:partial => 'lk/commercial_offers/co_item_row', :locals => {:item => @item} ) %>")
      $("#<%= dom_id(@item) %> td.product-picture").effect('highlight', 2000)
      $("#logo_dialog").dialog("close")
    } );    

