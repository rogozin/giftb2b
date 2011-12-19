$ = jQuery

$ -> 
  example = document.getElementById("logo_transform")
  ctx = example.getContext('2d')
  bg = new Image()
  logo = new Image()
  l_x= 40
  l_y = 40
  sc = 1
  grad=0
  rw = false
  logo_w = logo_h = 0
#  bg.src = 'http://giftb2b.ru/system/pictures/150351/original/0000056595.jpg'
#  logo.src = 'http://giftpoisk.ru/system/pictures/37182/thumb/logo_dishouse.jpg'
  bg.src = $(example).data('picture-url')


  draw_bg = ->
    ctx.drawImage(bg, 0, 0)
   
  draw_logo = (x,y) ->
    logo_w = logo.width * sc
    logo_h = logo.height * sc  
    ctx.drawImage(logo, x, y, logo_w, logo_h)
              
  bg.onload = ->
    draw_bg();
    logo.src = $(example).data('logo-url')      

  logo.onload = ->  
    logo_w = logo.width * sc
    logo_h = logo.height * sc  
    draw_logo(l_x,l_y)
      
  draw = (x,y) ->
    update_debug()  
    if grad == 0
      draw_bg()
      draw_logo(x,y)
    else
      rotate(grad)

  rotate = (grad) ->
   draw_bg()
   ctx.save()
   ctx.setTransform(1,0,0,1,0,0)     
   rads = grad * Math.PI / 180;
   ctx.translate(l_x + logo_w/2, l_y + logo_h/2)
   ctx.rotate(rads)
   draw_logo(logo_w/-2, logo_h/-2)
   ctx.restore()
   
  remove_white =  ->
    tmp_c = document.createElement('canvas')
    w = logo.width
    h = logo.height    
    tmp_c.width = w
    tmp_c.height = h
    
    tmp_ctx = tmp_c.getContext('2d')
    
    tmp_ctx.width = w
    tmp_ctx.height = h
    tmp_ctx.drawImage(logo, 0,0,w,h)
        
    imageData = tmp_ctx.getImageData(0,0,w,h)
    pixel = imageData.data
    for p, i in pixel by 4
      pixel[i+3] = 0 if pixel[i+0] == 255 && pixel[i+1] == 255 && pixel[i+2] == 255                 
    tmp_ctx.putImageData(imageData,0, 0)
    tmp_c.toDataURL('image/png')  

      
  move = (direction) ->
    switch direction
      when 0 then l_y -=1 if l_y - 1 > 0
      when 1 then l_x +=1 if l_x + 1 + logo_w < bg.width
      when 2 then l_y +=1 if l_y + 1 + logo_h < bg.height
      when 3 then l_x -=1 if l_x - 1 > 0
    draw(l_x, l_y)

  scale = (direction) ->  
    switch direction
      when 0
        sc = sc-=0.1 if sc > 0.4
      when 1  
        sc = sc+=0.1 if sc < 2.4
    draw(l_x, l_y)      

  do_rotate = (direction) ->
   grad += if direction == 0  then-5 else 5
   rotate(grad)
    
  document.onkeydown = (e) ->
    e= if e then e else window.event
    console.log e.keyCode
    switch e.keyCode
      when 38 then move(0)
      when 39 then move(1)
      when 40 then move(2)
      when 37 then move(3)
      when 109 then scale(0)
      when 107 then scale(1)
      when 188 then do_rotate(0)    
      when 190 then do_rotate(1)
      
  update_debug = ->
      $("#l_x").val(l_x)
      $("#l_y").val(l_y)
      $("#sc").val(sc)    
      $("#rt").val(grad)    

  $("#remove_white").click ->
       draw_bg()
       logo.src = remove_white()
   
