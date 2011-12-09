$('#commercial_offer_items').html("<%= escape_javascript render(:partial => 'commercial_offer_items') %>")
$("#co_form .b-submit").hide()
#<%- flash.each do |name, msg| -%>
#$('<div class="corner-all" id="flash_<%= name %>"><%= msg.html_safe %></div>').appendTo("#flashes").fadeOut(3000)
#<%- end -%>
#<% flash.discard %>
    
