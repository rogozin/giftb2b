#encoding: utf-8;
module Lk
  class ApplicationController < ActionController::Base
 # helper_method :current_user, :giftpoisk?
    
  helper GiftHelper
  helper SearchHelper
  helper CartHelper
  helper UsersHelper
  helper CategoriesHelper  
  helper ProductsHelper  
  
  rescue_from  'Acl9::AccessDenied',  :with => :access_denied
  rescue_from  'ActiveRecord::RecordNotFound' do |ex|
    render :file => 'public/404.html', :status => 404, :layout => false
  end

  protected
  def access_denied
     flash[:alert] = 'Доступ запрещен.'
     redirect_to auth_engine.login_path
  end

  end
end
