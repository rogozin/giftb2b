#encoding: utf-8;
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base  

  rescue_from  'Acl9::AccessDenied',  :with => :access_denied
  rescue_from  'ActiveRecord::RecordNotFound',  :with => :not_found
 # helper :all # include all helpers, all the time
  helper GiftHelper
  helper UsersHelper
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '14d398aec746ebb20e8f187bda7c3ba3'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  helper_method :current_user, :ext_user?

  private
  def access_denied
     if current_user
       # It's presumed you have a template with words of pity and regret
       #  # for unhappy user who is not authorized to do what he wanted
       render :template => 'access_denied'
     else
       ## In this case user has not even logged in. Might be OK after login.
     flash[:alert] = 'Доступ запрещен. Попробуйте выполнить вход в систему'
     redirect_to login_path
    end
  end

  def not_found(message=nil)    
    #flash[:alert] = message if message
    #raise ActionController::RoutingError.new('Not Found')
    render :file => 'public/404.html', :status => 404, :layout => false
  end  


  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def find_cart    
    session[:cart] ||= Cart.new          
  end
  
  def get_cart
    @cart = find_cart
  end

end

