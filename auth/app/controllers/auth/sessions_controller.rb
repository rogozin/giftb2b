class Auth::SessionsController < Devise::SessionsController
include Auth::DeviseMix

  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    return redirect_to_other(resource) if resource && giftb2b? && resource.is_firm_user? && !resource.is_admin?
    return redirect_to_other(resource) if resource && giftpoisk? && resource.is_simple_user?    
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)    
  end



  private
  
  def redirect_to_other(resource)
#    sign_out(resource)
    warden.logout(:user)
    host = giftb2b? ? "http://giftpoisk.ru" : "http://giftb2b.ru"
    token =  "/?token=#{resource.authentication_token}"              
    redirect_to(host+token)
  end
  
end
