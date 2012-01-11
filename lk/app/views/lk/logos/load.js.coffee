$("#logo_stack").html '<img src="<%=@src %>" alt="<%= @file_name %>" />'
$(".logo_transform_modal #logo").empty()
$('.logo_transform_modal #logo').data 'logo-url', "<%= @src %>"
tr = $('.logo_transform_modal #logo').logoTransform({
    onsave: (data) -> 
      $("#<%= dom_id(@item)%> td.product-picture a img").attr("src", data)
      $("#<%= dom_id(@item) %> td.product-picture").effect('highlight', 2000)
      $("#logo_dialog").dialog("close")
    } );    

