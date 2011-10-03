#encoding: utf-8;
require 'will_paginate/array'
class Api::BaseController < ActionController::Base  
  respond_to :json
  before_filter :authorization  
  
  protected
  
  def is_lk_product?(product_id = params[:id])
    product_id =~ /^(lk|my)-/ 
  end
  
  def find_lk_product(product_id = params[:id])
    LkProduct.find(product_id.match(/\d+/).to_s)
  end
  
  def respond_with( object, options = {})
    options.merge!(:callback => params[:callback]) if params[:callback]
    options.merge!(:status => :not_found) unless object.present?       
    super(object, options)
  end

  
  private
  def authorization
   #request.headers.each {|k,v| logger.info "#{k} = #{v}"}
   #logger.info "==request auth=#{request.authorization.to_s}"
   authenticate_or_request_with_http_token do |t,o|
      access = ForeignAccess.accepted_clients.select{|x| x.param_key == t}
      #logger.info "token=#{t} opts=#{o}"
      @firm = access.first.firm if access.present?
      access.present?
    end
   end
end
