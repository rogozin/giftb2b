#encoding: utf-8;
class Admin::BaseController < ApplicationController
  #before_filter :require_user
  before_filter :authenticate_user!
  layout 'admin'
  
  
  protected 
    def redirect_back path, status
        redirect_to( params[:return_to].present? ? params[:return_to] : path, :flash => status)
    end
end
