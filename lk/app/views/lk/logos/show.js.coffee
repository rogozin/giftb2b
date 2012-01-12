jQuery -> 
  $(".logo_transform_modal").remove()
  dlg  = '<%= escape_javascript render(:partial => "logo_transform") %>'
  $(dlg).dialog modal: false
  dialogClass: 'logo_transform_modal'
  title: "Нанесение логотипа"
  width: 800
  close: -> 
    $(this).remove() 
  create: -> 
    #$('.logo_transform_modal #logo').logoTransform();    
