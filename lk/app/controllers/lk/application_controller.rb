#encoding: utf-8;
module Lk
  class ApplicationController < ActionController::Base
  helper_method :current_user
    
  helper GiftHelper
  helper CartHelper
  helper UsersHelper
  helper CategoriesHelper  

  end
end
