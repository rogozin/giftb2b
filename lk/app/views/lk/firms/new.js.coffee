jQuery -> 
  $(".new_client_modal").remove()
  $('<%= escape_javascript render(:partial => "firm", :locals => {:remote => true}) %>').dialog modal: true
  dialogClass: 'new_client_modal'
  title: "Новый клиент"
  width: 380
  close: -> 
    $(this).remove()
  
