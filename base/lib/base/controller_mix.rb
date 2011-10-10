module Base
  module ControllerMix
   def find_cart    
    session[:cart] ||= Cart.new          
  end
 end 
end
