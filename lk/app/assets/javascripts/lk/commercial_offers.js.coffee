calc_co = (id, quantity) ->
  $.post "/lk/commercial_offer/calc_single/#{id}", 
    quantity:
      quantity
  false            
    
window.save_co = -> 
  $.ajax 
    type: "PUT"
    dataType: "script"   
    url:window.location.pathname
    data: 
      commercial_offer:
        lk_firm_id: $('#lk_firm_id').val()
        signature: $('#signature').val()
        name: $("#name").val()
  false      
    
modify = (target) -> 
  $.post $('#modify_form').data('action'), 
    'co_items[]':
      $("#co_form input:checked").map -> 
        this.value
      .get()
    logo:
     if target == "modify_logo" then $("#logo").val() else ""
    delta:
     if target == "modify_delta" then $("#delta").val() else ""      
    sale:
     if target == "modify_sale" then $("#sale").val() else ""      
    unit:
      $("#unit").val()        
  false        

jQuery ->
  $("#co_form .b-submit").hide()
  bindAnimation()
  $('#co_settings input:checkbox').click -> 
    _id = this.id
    _val = "#{_id}=#{if this.checked then 1 else 0}"
    $('#co_output_links a').each ->
      pattern = new RegExp(_id + '=\\d');
      this.href = this.href.replace(pattern, _val);
    
  $("#select_all").toggle ->  
      this.src = "/assets/checked.gif"
      this.title = "Снять выделение"
      $('td.checkbox-container input:checkbox').attr 'checked', true
    ,
    ->
      this.src="/assets/unchecked.gif";
      this.title="Выбрать все";
      $('td.checkbox-container input:checked').attr 'checked', false
      
  $("#lk_firm_id").live 'change', ->
    save_co()

  co_timer = true    
  calc_timer = true
  
  digital_key = (key_code)->
    key_code in [8,46] || key_code in [47..57] || key_code in [96..105]     
  nav_key = (key_code)->
    key_code in [33..40] || key_code == 45
  plus_minus_key = (key_code)-> 
    key_code in [107,107,187,189]
  
  $("#co_form input[type='text']").live 'keydown', (event)->  
    if digital_key event.which
      if calc_timer
        calc_timer = false
        $(this).oneTime 1000, -> 
          _id = $(this).attr('name').match(/\d+/)[0]
          calc_co(_id, $(this).val()) if $(this).val() 
          calc_timer = true        
    else if nav_key(event.which)
      true
    else
      false

  $("#name, #signature").live 'keydown', (event)->  
    if event.which in [9,13,32,106,107,109,111,222] || event.which in [65..97] || digital_key(event.which) || event.which in [186..192] 
      if co_timer
        co_timer = false
        $(this).oneTime 3000, -> 
          save_co()
          co_timer = true          

  $('#delta input[type="text"]').live 'keydown', (event)-> 
    digital_key(event.which) || nav_key(event.which) || plus_minus_key(event.which)

  check_checked_items = -> 
    if $("#co_form input:checked").size() == 0
      $('#co_form input:checkbox').effect('pulsate')
      $('<div class="alert">Отметьте галочкой товар для изменения стоимости</div>').appendTo('#delta_messages').delay(2000).fadeOut(500)
    $("#co_form input:checked").size() > 0

  $('#modify_form button').live 'click', -> 
    if check_checked_items()
      modify(this.id)
    false        
