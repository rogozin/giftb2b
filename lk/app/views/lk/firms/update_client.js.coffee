$("#lk_firm_id").append '<option value="<%= @firm.id %>" selected="selected"><%=escape_javascript @firm.name.html_safe %></option>'
$("#lk_firm_id").effect('highlight', 2000)
$("#new_client_modal").modal 'hide'
save_co()

