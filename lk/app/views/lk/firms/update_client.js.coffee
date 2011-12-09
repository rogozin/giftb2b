$("#lk_firm_id").append '<option value="<%= @firm.id %>" selected="selected"><%=escape_javascript @firm.name.html_safe %></option>'
$("#lk_firm_id").effect('highlight', 2000)
$("#new_lk_firm").dialog("close")
save_co()

