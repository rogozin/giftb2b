<% if @src %>
$("#logo_stack").html '<img src="<%=@src %>" alt="<%= @file_name %>" />'
$("#logo_dialog #logo").empty()
$('#logo_dialog #logo').data 'logo-url', "<%= @src %>"
tr = $('#logo_dialog #logo').logoTransform({
    onsave: (data) -> 
      $("#<%= dom_id(@item)%> td.product-picture a img").attr("src", data)
      $("#<%= dom_id(@item) %> td.product-picture").effect('highlight', 2000)
      $("#logo_dialog").modal("hide").remove()
    } );    
<% else %>      
 $("#logo_stack").html '<div class="alert alert-error"><%= @message if defined?(@message) %></div>'
<% end %>

