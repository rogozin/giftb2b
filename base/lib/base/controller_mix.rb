module Base
  
  module ControllerMix  
   
   def not_found(message=nil)    
    render :file => 'public/404.html', :status => 404, :layout => false
  end  
  
  protected :not_found
  
   def find_cart    
    session[:cart] ||= Cart.new          
  end
 end 
end
