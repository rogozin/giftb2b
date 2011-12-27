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
    @save_url = $(@element).data('save-url')
    @logo_url = $(@element).data('logo-url') 
    @bg = new Image()
    @bg.src = $(@element).data('picture-url')
    $(@bg).bind 'load', () =>
      @canvas.width = @bg.width
      @canvas.height = @bg.height
      @drawBg()
      @logo = new Logo(40,40, @logo_url , @ctx)
      @updateDebug()
    $(document).unbind 'keydown'    
    $('.controls span').unbind 'click'
    $('#save').unbind 'click'
    $(@canvas).unbind 'mousedown', 'mouseup'
    $(document).bind 'keydown',  (e) =>
      e = if e then e else window.event
      console.log e.keyCode
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
                  
          
    $(".remove-bg").bind 'click', () =>          
      @removeLogoBg()
        
    $(".rotate-left").bind 'click', () =>          
      @rotate(0)
        
    $(".rotate-right").bind 'click', () =>          
      @rotate(1)

    $(".zoom-out").bind 'click', () =>          
      @scaleByKey(0)
      
    $(".zoom-in").bind 'click', () =>          
      @scaleByKey(1)      
      
    $("#save").bind 'click', () =>          
      @save()
      
    $(@canvas).bind 'mousedown', (e) =>     
      console.log "mouse down on  #{@coord(e).x}:#{@coord(e).y}. x=#{@logo.x}, y=#{@logo.y},  w=#{@logo.w}, h=#{@logo.h}"
      if @logo?.mouseOnMe @coord(e)
        $(@canvas).bind 'mousemove', (e) => 
          @moveByMouse @coord(e)
      att = @logo?.mouseOnSelectionRect @coord(e)    
      console.log "scale by mouse #{att}"      
      if att > -1
         $(@canvas).bind 'mousemove', (e) => 
          @scaleByMouse @coord(e), att
      false

    $(@canvas).bind 'mouseup', (e) => 
      $(@canvas).unbind 'mousemove'

  coord: (mouseevent) ->    
    offset = $(@canvas).offset()
    {x: mouseevent.pageX - offset.left, y: mouseevent.pageY - offset.top}
    
  createCanvas: ->
    canvas = document.createElement('canvas')
    c = $(canvas)
    $(@element).html(c)
    canvas

  drawBg: ->
    @canvas.width = @canvas.width
    @ctx.drawImage(@bg, 0, 0)
                         
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
          @logo.sc = {x:@logo.sc.x-=0.1, y:@logo.sc.y-=0.1} if @logo.sc.x + @logo.sc.y> 0.8 
        when 1  
          @logo.sc = {x:@logo.sc.x+=0.1, y:@logo.sc.y+=0.1} if  @logo.sc.x + @logo.sc.y < 4.8
      @logo.calcSizeByScale()    
      @draw()   
    false   
    
  scaleByMouse: (coord, att ) -> 
    return false if coord.x < 1 || coord.y < 1 || @logo.w < 8 || @logo.h < 8  
    switch att 
      when 0
        @logo.w = @logo.w + (@logo.x - coord.x)
        @logo.h = @logo.h + (@logo.y - coord.y)
        @logo.x = coord.x
        @logo.y = coord.y
      when 1 
        @logo.w =  coord.x - @logo.x
        @logo.h = @logo.h + (@logo.y - coord.y)
        @logo.y = coord.y
      when 2 
        @logo.w = coord.x - @logo.x
        @logo.h = coord.y - @logo.y
      when 3 
        @logo.w = @logo.w + @logo.x - coord.x
        @logo.h = coord.y - @logo.y
        @logo.x = coord.x
    @logo.w = 8 if @logo.w < 8    
    @logo.h = 8 if @logo.h < 8    
    @logo.calcScale()
    @draw()  
    false
    
  save: ->
    $.ajax 
      type: "PUT"
      dataType: "json"   
      url: @save_url
      success:  => 
        console.log "ajax succ"    
        @settings.onsave()  if @settings.onsave &&  typeof @settings.onsave == "function"
      data:
        picture:     
          @pictureToUrl()
    false      
  
  pictureToUrl: -> 
    tmp_c = document.createElement('canvas')
    tmp_ctx = tmp_c.getContext('2d')    
    tmp_c.width = @bg.width
    tmp_c.height = @bg.height    
    tmp_ctx.drawImage(@bg, 0,0)      
    logo = new Logo(@logo.x,@logo.y, @logo_url , tmp_ctx, @logo.grad)
    logo.noSelectionRect = true
    logo.w = @logo.w
    logo.h = @logo.h
    logo.draw()
    tmp_c.toDataURL('image/png')  
          
  updateDebug: ->
    $("#l_x").val @logo.x
    $("#l_y").val @logo.y
    $("#sc").val Math.floor(@logo.sc * 100) + "%"
    $("#rt").val @logo.grad % 360   


      
  removeLogoBg: ->   
    @drawBg()  
    @logo = new Logo(@logo.x, @logo.y, @logo.removeWhite(), @ctx, @logo.grad)       
      

class Logo
  constructor:(@x, @y, src, @ctx, @grad = 0 ) -> 
    @sc = {x:1, y:1}      
    @noSelectionRect = false
    @w = @h = 0
    @cursorDistance = {x: 0, y: 0}    
    @img = new Image()
    @img.src = src
    $(@img).bind 'load', () =>  
      @calcSizeByScale()
      @draw()
 
  calcSizeByScale: -> 
    @w = Math.round @img.width * @sc.x
    @h = Math.round @img.height * @sc.y  
  
  calcScale: -> 
    @sc = { x: @w / @img.width, y: @h /  @img.height }
      
  attitude: -> [{x:@x, y:@y}, {x: @x + @w, y: @y}, {x: @x + @w, y: @y + @h}, {x:@x, y:@y + @h}]
  
  drawSelectionRect:  -> 
    @ctx.fillStyle = "rgba(80, 80, 80, 0.8)"
    @ctx.strokeStyle = "rgba(80, 80, 80, 0.8)"
    @ctx.lineWidth = 1
    @ctx.strokeRect @x, @y, @w, @h
    for p in @attitude()
      @ctx.fillRect p.x-4, p.y-4, 8, 8

    
  draw: (x = @x,y = @y, w = @w, h = @h) ->
    console.log "draw logo in #{x},#{y} size #{w}, #{h}"
    if @grad == 0  
      @ctx.drawImage(@img, x, y, w, h)
      @drawSelectionRect() unless @noSelectionRect
    else
      @rotate(x, y, w, h)
        
  rotate: (x = @x, y = @y, w = @w, h = @h) ->
   @ctx.save()
   @ctx.setTransform(1,0,0,1,0,0)     
   rads = @grad * Math.PI / 180
   @ctx.translate(x + w / 2, y + h / 2)
   @ctx.rotate(rads)
   @x=w/-2
   @y=h/-2
   @ctx.drawImage(@img, @x, @y, w, h)
   @drawSelectionRect() unless @noSelectionRect
   @ctx.restore()
   @x = x
   @y = y
   
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
    
  mouseOnSelectionRect: (coord) -> 
    rad = (@grad) * (Math.PI/180)
    x1 = -1*(@w/2) * Math.cos(rad) + (@h/2) * Math.sin(rad)
    y1 = (@w/2) * Math.sin(rad) + (@h/2) * Math.cos(rad)
    console.log "смещение по осям (х:y) =  #{x1}:#{y1}"
    console.log "координаты вершины (х:y) =  #{@x + (@w/2-Math.abs(x1))}:#{@y + (@h/2-Math.abs(y1))}"
    #coord.x in [@x-4..@x+4] && coord.y in [@y-4..@y+4]
    for p, i in @attitude()
      return i if coord.x in [p.x-4..p.x+4] && coord.y in [p.y-4..p.y+4]
    -1 
   
   
