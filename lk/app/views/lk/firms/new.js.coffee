jQuery -> 
  $("#new_client_modal").modal('hide').remove()
  $('<%= escape_javascript render(:partial => "modal") %>').modal 'show'
