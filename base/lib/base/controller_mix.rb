module Base
  module ControllerMix
  
  def giftpoisk?
    ActionMailer::Base.default_url_options[:host] == "giftpoisk.ru"
  end
    
   def not_found(message=nil)    
    render :file => 'public/404.html', :status => 404, :layout => false
  end  

    
   def find_cart    
    session[:cart] ||= Cart.new          
  end
 end 
end
