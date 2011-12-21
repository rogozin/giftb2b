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
    @bg = new Image()
    @bg.src = $(@element).data('picture-url')
    $(@bg).bind 'load', () =>
      @canvas.width = @bg.width
      @canvas.height = @bg.height
      @draw_bg()
      @logo = new Logo(40,40, $(@element).data('logo-url') , @ctx)
  
    $(document).bind 'keydown',  (e) =>
      e = if e then e else window.event
      console.log e.keyCode
      switch e.keyCode
        when 38, 104 then @move(0)
        when 39, 102 then @move(1)
        when 40, 98 then @move(2)
        when 37, 100 then @move(3)
        when 109, 189 then @scale(0)
        when 107, 187 then @scale(1)
        when 188 then @rotate(0)    
        when 190 then @rotate(1)
      false    
    $("#remove_white").bind 'click', () =>          
      @remove_logo_bg()
    $("#save").bind 'click', () =>          
      @save()

  createCanvas: ->
    canvas = document.createElement('canvas')
    c = $(canvas)
    $(@element).replaceWith(c)
    canvas

  draw_bg: ->
    @canvas.width = @canvas.width
    @ctx.drawImage(@bg, 0, 0)
                         
  draw: ->
    @update_debug()  
    @draw_bg()
    @logo.draw()


  move: (direction) ->
    switch direction
      when 0 then @logo.y -=1 if @logo.y - 1 > 0
      when 1 then @logo.x +=1 if @logo.x + 1 + @logo.w < @bg.width
      when 2 then @logo.y +=1 if @logo.y + 1 + @logo.h < @bg.height
      when 3 then @logo.x -=1 if @logo.x - 1 > 0
    @draw(@logo.x, @logo.y)

  rotate: (direction) ->
    @logo.grad += if direction == 0  then-5 else 5
    @draw()

  scale: (direction) ->  
    switch direction
      when 0
        @logo.sc = @logo.sc-=0.1 if @logo.sc > 0.4
      when 1  
        @logo.sc = @logo.sc+=0.1 if @logo.sc < 2.4
    @draw()      
    
  save: ->
    $.ajax 
      type: "PUT"
      dataType: "script"   
      url: @save_url
      data:
        picture:     
          @canvas.toDataURL('image/png')  
          
  update_debug: ->
    $("#l_x").val(@logo.x)
    $("#l_y").val(@logo.y)
    $("#sc").val(@logo.sc)    
    $("#rt").val(@logo.grad)    


      
  remove_logo_bg: ->   
    @draw_bg()
    console.log "removing white color"
    @logo = new Logo(@logo.x, @logo.y, @logo.remove_white(), @ctx, @logo.grad)       
      

class Logo
  constructor:(@x, @y, src, @ctx, @grad = 0 ) -> 
    @sc = 1      
    @w = @h = 0
    @img = new Image()
    @img.src = src
    $(@img).bind 'load', () =>  
      @draw()
 
  calc_scale: -> 
      @w = @img.width * @sc
      @h = @img.height * @sc   
      
  draw: (x = @x,y = @y) ->
    @calc_scale()    
    console.log "draw logo in #{x},#{y} size #{@w}, #{@h}"
    if @grad == 0  
      @ctx.drawImage(@img, x, y, @w, @h)
    else
      @rotate(@grad)      
        
  rotate: (grad) ->
   @ctx.save()
   @ctx.setTransform(1,0,0,1,0,0)     
   rads = grad * Math.PI / 180;
   @ctx.translate(@x + @w / 2, @y + @h / 2)
   @ctx.rotate(rads)
   @ctx.drawImage(@img, @w / -2, @h / -2, @w, @h)
   @ctx.restore()
   
  remove_white:  ->
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
      
   
