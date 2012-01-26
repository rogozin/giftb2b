#encoding: utf-8;
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base  


  rescue_from  'ActiveRecord::RecordNotFound' do |ex|
    render :file => 'public/404.html', :status => 404, :layout => false
  end
  
 # helper :all # include all helpers, all the time
  helper GiftHelper
  helper UsersHelper
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => 'g3mn002jnaskhmb690dnps3826nmsls3ajd'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  #helper_method  :ext_user?, :giftpoisk?

  protected
  def not_found(message=nil)    
    render :file => 'public/404.html', :status => 404, :layout => false
  end  

    
  private

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end

