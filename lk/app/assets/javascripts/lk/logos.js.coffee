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
    #console.log "bg src is #{@bg.src}"
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
      console.log "background w:h = #{@bg.width}:#{@bg.height}"
      @drawBg()
      @logo = new Logo(20,20, @logoUrl , @ctx)
      @updateDebug()  
    $(document).unbind 'keydown'    
    $('.controls div').unbind 'click'
    $('#save').unbind 'click'
    $(@canvas).unbind 'mousedown', 'mouseup'
    $(document).bind 'keydown',  (e) =>
      e = if e then e else window.event
      console.log e
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
      #console.log "mouse down on  #{@coord(e).x}:#{@coord(e).y}. x=#{@logo.x}, y=#{@logo.y},  w=#{@logo.w}, h=#{@logo.h}"
      if @logo?.mouseOnMe @coord(e)
        $(@canvas).bind 'mousemove', (e) => 
          @moveByMouse @coord(e)
      att = @logo?.mouseOnSelectionRect @coord(e)    
      #console.log "scale by mouse #{att}"      
      if att > -1
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
    rad = @logo.getRads()
    mouseX = @logo.x + @logo.w/2 +  (coord.x-@logo.x-@logo.w/2) * Math.cos(rad) +  (coord.y-@logo.y-@logo.h/2) * Math.sin(rad)
    mouseY = @logo.y + @logo.h/2 - (coord.x-@logo.x-@logo.w/2) * Math.sin(rad) + (coord.y-@logo.y-@logo.h/2) * Math.cos(rad)       
    att_shift = 0
#    att_shift = Math.floor(@logo.grad / 90) % 4 
#    console.log "att_id = #{att_id}, att_shift= #{att_shift}, total = #{(att_id + att_shift) % 4}"
#    console.log "coordX:coordY=#{coord.x}:#{coord.y}"
#    console.log "mouseX:mouseY=#{mouseX}:#{mouseY}"
    switch (att_id + att_shift) % 4
      when 0
        @logo.w = @logo.w + (@logo.x - mouseX)
        @logo.h = @logo.h + (@logo.y - mouseY)
        @logo.x = mouseX
        @logo.y = mouseY
      when 1 
        @logo.w = mouseX - @logo.x
        @logo.h = @logo.h + (@logo.y - mouseY)
        @logo.y = mouseY
        #coord.y
      when 2 
        switch att_shift 
          when 0
            @logo.w = mouseX - @logo.x
            @logo.h = mouseY - @logo.y
#          when 1
#            @logo.x = 
#            @logo.y = 
#            @logo.h = coord.x - @logo.x
#            @logo.w = coord.y - @logo.y
                        
      when 3 
        @logo.w = @logo.w + @logo.x - mouseX
        @logo.h = mouseY - @logo.y
        @logo.x = mouseX
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
    $(@img).bind 'load', () =>  
      if @img.width > 300
        dimension  = @img.width / 300
        @img.width = 300
        @img.height = @img.height / dimension
      else if @img.height > 300 
        dimension  = @img.height / 300
        @img.height = 300
        @img.width = @img.width / dimension
      @w = Math.round @img.width * @sc      
      @h = Math.round @img.height * @sc
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
    console.log "draw logo in #{x},#{y} size #{w}, #{h}"
    @ctx.save()
    @ctx.setTransform(1,0,0,1,0,0)     
    @ctx.translate(x + w / 2, y + h / 2)
    @ctx.rotate(@getRads())
    @ctx.drawImage(@img, w/-2, h/-2, w, h)
    @drawSelectionRect(w/-2, h/-2, w, h)
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
    (coord.x  > @x + 4 && coord.x < @x + @w - 4) && (coord.y > @y + 4 && coord.y < @y+@h - 4)
      
  coordWithRotationShift: (x,y,w,h) ->
    rad  = @getRads()
    shift = [{x:  (-w/2) * Math.cos(rad) + (h/2) * Math.sin(rad), y: (w/2) * Math.sin(rad) + (h/2) * Math.cos(rad) },
             {x:  (w/2) * Math.cos(rad) +  (h/2) * Math.sin(rad), y: -(w/2) * Math.sin(rad) + (h/2) * Math.cos(rad) },
             {x:  (w/2) * Math.cos(rad) +  (-h/2) * Math.sin(rad), y: -(w/2) * Math.sin(rad) + (-h/2) * Math.cos(rad) },
             {x:  (-w/2) * Math.cos(rad) +  (-h/2) * Math.sin(rad), y: (w/2) * Math.sin(rad) + (-h/2) * Math.cos(rad) }]
    att = []     
#    @ctx.fillStyle = "red"
    for p,i in shift
      att[i] = {x: Math.round(p.x + x + w/2) , y:Math.round(y - p.y + h/2)}
#    for p, i in att  
#      @ctx.fillRect p.x-(i+2)/2 , p.y-(i+2)/2, i + 2, i + 2
    att

    
  mouseOnSelectionRect: (coord) -> 
    for p, i in @coordWithRotationShift(@x,@y,@w,@h)
      #console.log "координаты вершины[#{i}] (х:y) =  #{p.x}:#{p.y}"      
      return i if coord.x in [p.x-4..p.x+4] && coord.y in [p.y-4..p.y+4]
    -1 
   
