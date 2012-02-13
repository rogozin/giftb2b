jQuery -> 
#  $(".logo_transform_modal").remove()
  $("#logo_dialog").modal('hide').remove()
  dlg  = '<%= escape_javascript render(:partial => "logo_transform") %>'
  $(dlg).modal 'show'
#  dialogClass: 'logo_transform_modal'
#  title: "Нанесение логотипа"
#  width: 800
#  close: -> 
#    $(this).remove() 
#  create: -> 
    #$('.logo_transform_modal #logo').logoTransform();    
