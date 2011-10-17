module Base
  module ControllerMix


  
  def giftpoisk?
    ActionMailer::Base.default_url_options[:host] == "giftpoisk.ru"
  end
    
  def giftb2b?
    ActionMailer::Base.default_url_options[:host] == "giftb2b.ru"
  end  
    
   def not_found(message=nil)    
    render :file => 'public/404.html', :status => 404, :layout => false
  end  
  
  protected :not_found
  
   def find_cart    
    session[:cart] ||= Cart.new          
  end
 end 
end
