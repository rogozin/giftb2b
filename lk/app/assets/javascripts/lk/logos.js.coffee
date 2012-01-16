$ = jQuery

$.fn.extend
  logoTransform: (options) ->
    settings = 
      log: false
      
    settings = $.extend settings, options
    
    return @each ->
      new LogoTransform this, settings 

class LogoTransform
  constructor: (@element, @settings) ->     
    @canvas = @createCanvas()    
    @ctx = @canvas.getContext('2d')
    @rw = false
    @saveUrl = $(@element).data('save-url')
    @logoUrl = $(@element).data('logo-url') 
    @bg = new Image()
    @bg.src = $(@element).data('picture-url')
    $(@bg).bind 'load', () =>
      @bgOriginalSize = { w: @bg.width, h: @bg.height }
      @bgScale = {w: @bg.width / 450, h: @bg.height / 450}
      if @bg.width >= @bg.height
        @bg.width = 450
        @bg.height = Math.round(@bg.height / @bgScale.w)
        @bgScale.h = @bgScale.w
      else
        @bg.height = 450
        @bg.width = Math.round(@bg.width / @bgScale.h)
        @bgScale.w = @bgScale.h
      @canvas.width = @bg.width
      @canvas.height = @bg.height
      @ctx.width = @bg.width
      @ctx.height = @bg.height
      @drawBg()
      @logo = new Logo(120,120, @logoUrl , @ctx)
      @updateDebug()  
    $(document).unbind 'keydown'    
    $('.controls div').unbind 'click'
    $('#save').unbind 'click'
    $(@canvas).unbind 'mousedown', 'mouseup'
    $(document).bind 'keydown',  (e) =>
      e = if e then e else window.event
      switch e.keyCode
        when 38, 104 
          @moveByKey(0)
        when 39, 102
          @moveByKey(1)
        when 40, 98
          @moveByKey(2)
        when 37, 100 
          @moveByKey(3)
        when 109, 189 
          @scaleByKey(0)
        when 107, 187 
          @scaleByKey(1)
        when 188 
          @rotate(0)    
        when 190
          @rotate(1)
                  
          
    $(".remove-bg").parent().bind 'click', () =>          
      @removeLogoBg()
        
    $(".rotate-left").parent().bind 'click', () =>          
      @rotate(0)
        
    $(".rotate-right").parent().bind 'click', () =>          
      @rotate(1)

    $(".zoom-out").parent().bind 'click', () =>          
      @scaleByKey(0)
      
    $(".zoom-in").parent().bind 'click', () =>          
      @scaleByKey(1)      
      
    $("#save").bind 'click', () =>          
      @save()
      
    $(@canvas).bind 'mousedown', (e) =>     
      if @logo?.mouseOnMe @coord(e)
        $(@canvas).bind 'mousemove', (e) => 
          @moveByMouse @coord(e)
      att = @logo?.mouseOnSelectionRect @coord(e)    
      if att > -1
        @logo.cursorDistance.x= @coord(e).x
        @logo.cursorDistance.y= @coord(e).y	     
        for j in [0..3]
          @logo.rect_coords_fixed[j].x= @logo.rect_coords[j].x	
          @logo.rect_coords_fixed[j].y= @logo.rect_coords[j].y 		                     
        $(@canvas).bind 'mousemove', (e) => 
          @scaleByMouse @coord(e), att
      false

    $(@canvas).bind 'mouseup', (e) => 
      $(@canvas).unbind 'mousemove'

  coord: (mouseevent) ->    
    offset = $(@canvas).offset()
    {x: Math.round(mouseevent.pageX - offset.left), y: Math.round(mouseevent.pageY - offset.top)}
    
  createCanvas: ->
    canvas = document.createElement('canvas')
    c = $(canvas)
    $(@element).html(c)
    canvas

  drawBg: ->
    @canvas.width = @canvas.width
    @ctx.drawImage(@bg, 0, 0, @bg.width, @bg.height)
                         
  draw: ->
    @updateDebug()  
    @drawBg()
    @logo.draw()

  moveByKey: (direction) ->
    switch direction
      when 0 then @logo.y -=1 if @logo.y - 1 > 0
      when 1 then @logo.x +=1 if @logo.x + 1 + @logo.w < @bg.width
      when 2 then @logo.y +=1 if @logo.y + 1 + @logo.h < @bg.height
      when 3 then @logo.x -=1 if @logo.x - 1 > 0
    @draw()
    false
      
  moveByMouse: (coord) ->    
    @logo.x = coord.x - @logo.cursorDistance.x
    @logo.y = coord.y - @logo.cursorDistance.y
    @draw()
    false
      
  rotate: (direction) ->
    @logo.grad += if direction == 0  then-5 else 5
    @draw()
    false

  scaleByKey: (direction) ->
    if @logo.x > 7 && @logo.y > 7  
      switch direction
        when 0
          if @logo.sc > 0.1
            @logo.sc = @logo.sc -= 0.1
            @logo.w -=  Math.round @logo.w * 0.1
            @logo.h -= Math.round @logo.h * 0.1
        when 1
          if @logo.sc < 3
            @logo.sc = @logo.sc += 0.1
            @logo.w +=  Math.round @logo.w * 0.1
            @logo.h += Math.round @logo.h * 0.1          
      @draw()   
    false   
    
  scaleByMouse: (coord, att_id ) -> 
    return false if coord.x < 1 || coord.y < 1 || @logo.w < 8 || @logo.h < 8              
    @logo.calc(coord, att_id)  				              
    @logo.w = 8 if @logo.w < 8    
    @logo.h = 8 if @logo.h < 8    
    #@logo.calcScale()
    @draw() 
    false
    
  save: ->
    $.ajax 
      type: "PUT"
      dataType: "json"   
      url: @saveUrl
      success: (data) => 
        @settings.onsave(data.picture)  if @settings.onsave &&  typeof @settings.onsave == "function"
      data:
        picture:     
          @pictureToUrl()
    false      
  
  pictureToUrl: -> 
    tmp_c = document.createElement('canvas')
    tmp_c.width = @bgOriginalSize.w
    tmp_c.height = @bgOriginalSize.h
    tmp_ctx = tmp_c.getContext('2d')    
    tmp_ctx.width = @bgOriginalSize.w
    tmp_ctx.height = @bgOriginalSize.h
    tmp_ctx.drawImage(@bg, 0,0,tmp_c.width, tmp_c.height )      
    logoAtt = { x:Math.round(@logo.x * @bgScale.w), y:Math.round(@logo.y * @bgScale.h), w:Math.round(@logo.w * @bgScale.w), h:Math.round(@logo.h * @bgScale.h) }
    tmp_ctx.setTransform 1,0,0,1,0,0
    tmp_ctx.translate logoAtt.x + logoAtt.w / 2, logoAtt.y + logoAtt.h / 2
    tmp_ctx.rotate @logo.getRads()
    tmp_ctx.drawImage @logo.img, logoAtt.w / -2, logoAtt.h / -2, logoAtt.w, logoAtt.h
    tmp_c.toDataURL('image/png')  
          
  updateDebug: ->
    $("#l_x").val @logo.x
    $("#l_y").val @logo.y
    $("#sc").val Math.floor(@logo.sc * 100) + "%"
    $("#rt").val @logo.grad % 360   
      
  removeLogoBg: ->   
    @drawBg()  
    @logo = new Logo(@logo.x, @logo.y, @logo.removeWhite(), @ctx)       
    @logo.grad = @logo.grad
    @rw = true
      

class Logo
  constructor:(@x, @y, src, @ctx, drawAfterLoad = true ) -> 
    @sc = 1
    @grad = 0
    @noSelectionRect = false
    @cursorDistance = {x: 0, y: 0}    
    @img = new Image()
    @img.src = src
    #==================================
    @rect_coords= [{x:0,y:0},{x:1,y:1},{x:2,y:2},{x:3,y:3}]
    @rect_coords_fixed= [{x:10,y:10},{x:11,y:11},{x:12,y:12},{x:13,y:13}]
    #==================================    
    $(@img).bind 'load', () =>  
      if @img.width > 300
        dimension  = @img.width / 300
        @img.width = 300
        @img.height = @img.height / dimension
      else if @img.height > 300 
        dimension  = @img.height / 300
        @img.height = 300
        @img.width = @img.width / dimension
      @w = Math.round @img.width/2 * @sc      
      @h = Math.round @img.height/2 * @sc
      @draw() if drawAfterLoad

  attitudes: (x,y,w,h) -> [{x:x, y:y}, {x: x + w, y: y}, {x: x + w, y: y + h}, {x:x, y:y + h}]
  
  drawSelectionRect: (x,y,w,h) -> 
    @ctx.fillStyle = "rgba(80, 80, 80, 0.8)"
    @ctx.strokeStyle = "rgba(80, 80, 80, 0.8)"
    @ctx.lineWidth = 1
    @ctx.strokeRect x, y, w, h
    for p in @attitudes(x,y,w,h)
      @ctx.fillRect p.x-4, p.y-4, 8, 8
    
  draw: (x = @x,y = @y, w = @w, h = @h) ->
    r1= Math.sqrt(@my_sqr(@w)+@my_sqr(@h));
    alfa1= Math.atan(@h/@w)*(180.0/Math.PI);
    @rect_calc_polar_pos(0,@x,@y,r1,@grad+alfa1);
    @rect_calc_polar_pos(1,@x,@y,r1,@grad+180.0-alfa1);
    @rect_calc_polar_pos(2,@x,@y,r1,@grad+180.0+alfa1);
    @rect_calc_polar_pos(3,@x,@y,r1,@grad+360.0-alfa1);
      
    @ctx.save()
    @ctx.setTransform(1,0,0,1,0,0)     
    @ctx.translate(x, y)
    @ctx.rotate(@getRads())
    @ctx.drawImage(@img, -w, -h, w*2, h*2)
#    @ctx.drawImage(@img, w/-2, h/-2, w, h)
    @drawSelectionRect(-w, -h, w*2, h*2)
    @ctx.restore()   
    

  getRads: (angle = @grad) -> 
    angle * Math.PI / 180     
          
  removeWhite:  ->
    tmp_c = document.createElement('canvas')
    tmp_c.width = @w
    tmp_c.height = @h    
    tmp_ctx = tmp_c.getContext('2d')    
    tmp_ctx.width = @w
    tmp_ctx.height = @h
    tmp_ctx.drawImage(@img, 0,0,@w,@h)        
    imageData = tmp_ctx.getImageData(0,0,@w,@h)
    pixel = imageData.data
    for p, i in pixel by 4
      pixel[i+3] = 0 if pixel[i+0] == 255 && pixel[i+1] == 255 && pixel[i+2] == 255                 
    tmp_ctx.putImageData(imageData,0, 0)
    tmp_c.toDataURL('image/png')  
      
  mouseOnMe: (coord) -> 
    @cursorDistance = {x: coord.x-@x, y: coord.y-@y}
    (coord.x  > @x-@w + 4 && coord.x < @x + @w - 4) && (coord.y > @y-@h + 4 && coord.y < @y+@h - 4)
      
  coordWithRotationShift: (x,y,w,h) ->
    rad  = @getRads()
    shift = [{x:  (w) * Math.cos(rad) +  (-h) * Math.sin(rad), y: -(w) * Math.sin(rad) + (-h) * Math.cos(rad) },
             {x:  (-w) * Math.cos(rad) +  (-h) * Math.sin(rad), y: (w) * Math.sin(rad) + (-h) * Math.cos(rad) }
             {x:  (-w) * Math.cos(rad) + (h) * Math.sin(rad), y: (w) * Math.sin(rad) + (h) * Math.cos(rad) },
             {x:  (w) * Math.cos(rad) +  (h) * Math.sin(rad), y: -(w) * Math.sin(rad) + (h) * Math.cos(rad) }]
    att = []     
#    @ctx.fillStyle = "red"
    for p,i in shift
      att[i] = {x: Math.round(p.x + x ) , y:Math.round(y - p.y )}
#    for p, i in att  
#      @ctx.fillRect p.x-(i+2)/2 , p.y-(i+2)/2, i + 2, i + 2
    att

    
  mouseOnSelectionRect: (coord) -> 
    for p, i in @coordWithRotationShift(@x,@y,@w,@h)    
      return i if coord.x in [p.x-4..p.x+4] && coord.y in [p.y-4..p.y+4]
    -1 
      
  calc: (coord, att_id) -> 
    dx= (coord.x - @cursorDistance.x)
    dy= (coord.y - @cursorDistance.y)  	
    x1= @rect_coords_fixed[att_id].x
    y1= @rect_coords_fixed[att_id].y
    xn= x1+dx
    yn= y1+dy
    @rect_coords[att_id].x= xn
    @rect_coords[att_id].y= yn	   
    indp= @prev_ind(att_id)  
    x2= @rect_coords_fixed[indp].x
    y2= @rect_coords_fixed[indp].y
    @calc_new_ppos(x1,y1,x2,y2,xn,yn)
    sz1= Math.sqrt(@my_sqr(xn-@x_tmp)+@my_sqr(yn-@y_tmp))/2 
    @rect_coords[indp].x= @x_tmp	 	
    @rect_coords[indp].y= @y_tmp	    
    indp= @next_ind(att_id) 
    x2= @rect_coords_fixed[indp].x
    y2= @rect_coords_fixed[indp].y
    @calc_new_ppos(x1,y1,x2,y2,xn,yn)
    sz2= Math.sqrt(@my_sqr(xn-@x_tmp)+@my_sqr(yn-@y_tmp))/2
    @rect_coords[indp].x= @x_tmp	 	
    @rect_coords[indp].y= @y_tmp		
    x1= 0
    y1= 0	
    for i in [0..3]		   
      x1+= @rect_coords[i].x
      y1+= @rect_coords[i].y	    
    @x= x1/4
    @y= y1/4	  
    if (att_id==1)||(att_id==3)	     			 
       @w= sz1;	  
       @h= sz2;
    else
       @h= sz1	  
       @w= sz2	
    
  my_sqr: (val)  -> 
    val * val

  rect_calc_polar_pos: (ind,xc,yc,r,ang) ->
    @rect_coords[ind].x= xc+r*Math.cos(@getRads(ang))
    @rect_coords[ind].y= yc+r*Math.sin(@getRads(ang))

  prev_ind: (ind) -> 
    if ind==0 then 3 else ind-1

  next_ind: (ind) -> 
    if ind==3 then 0 else ind+1
    
  calc_new_ppos: (x1,y1,x2,y2,xn,yn) -> 
    if (Math.abs(x2-x1)<0.01)
      @x_tmp= xn
      @y_tmp= y2
    else
      dx12= x2-x1
      dx12_2= @my_sqr(dx12)  
      dy12= y2-y1
      dy12_2= @my_sqr(dy12)  
      @y_tmp= ((x2-xn)*dx12*dy12+dx12_2*yn+dy12_2*y2)/(dx12_2+dy12_2)
      @x_tmp= x2+dy12*(y2-@y_tmp)/dx12
  
      
   
