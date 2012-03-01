#encoding: utf-8;
class BaseController < ApplicationController
  
 # helper_method :giftpoisk?, :giftb2b?
 before_filter :load_search_data
  rescue_from  'Acl9::AccessDenied',  :with => :access_denied  
  rescue_from  'ActiveRecord::RecordNotFound' do |ex|
    render :file => 'public/404.html', :status => 404, :layout => false
  end
  
  protected
  
  def access_denied
    if current_user
      render :template => 'shared/access_denied'
    else
      flash[:alert] = 'Недостаточно прав для просмотра страницы'
      redirect_to auth_engine.new_user_session_path
    end
  end
end
