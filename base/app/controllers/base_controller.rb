#encoding: utf-8;
class BaseController < ApplicationController
  
 # helper_method :giftpoisk?, :giftb2b?
  
  rescue_from  'ActiveRecord::RecordNotFound' do |ex|
    render :file => 'public/404.html', :status => 404, :layout => false
  end
  
  protected
  
  def require_ra_user
     require_user if giftpoisk?
  end
  
end
