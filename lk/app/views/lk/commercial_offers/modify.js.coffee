<% @co_items.each do |co_item| %>
  $("#<%= dom_id(co_item) %>").replaceWith("<%= escape_javascript render(:partial => 'lk/commercial_offers/co_item_row', :locals => {:item => co_item} ) %>")
  $("#<%= dom_id(co_item) %> td.sum").effect('highlight', 2000)    
  <% if params['sale'].present? %>
  $("#<%= dom_id(co_item) %> td.sale").effect('highlight', 2000)
  <% else %>
  $("#<%= dom_id(co_item) %> td.single-price").effect('highlight', 2000)  
  <% end %> 
<% end %>
  
<% if params['sale'].present? %>
  $("#sale").val ''
  $("#sale").focus()
<% end %>

<% if params['delta'].present? %>
  $("#delta").val ''
<% end %>

<% if params['logo'].present? %>
  $("#logo").val ''
<% end %>  
 
<% if flash[:notice].present? %>
  $('<div class="notice"><%= escape_javascript(flash[:notice]) %></div>').appendTo('#delta_messages').delay(3000).fadeOut(500)
<% end %>
  
<% if flash[:alert].present? %>
  $('<div class="alert"><%= escape_javascript(flash[:alert]) %></div>').appendTo('#delta_messages').delay(3000).fadeOut(500)
<% end %>  
  
<% flash.discard %>

