#encoding: utf-8;
class Api::BaseController < ActionController::Base  
  respond_to :json
  before_filter :authorization  
  
  private
  
#  def respond_with( object, options = {})
#    options = options.merge(:callback => params[:callback])
#    super(object, options)
#  end

  
  private
  def authorization
   #request.headers.each {|k,v| puts "#{k} = #{v}"}
   authenticate_or_request_with_http_token do |t,o|
      access = ForeignAccess.accepted_clients.select{|x| x.param_key == t}
      @firm = access.first.firm if access.present?
      access.present?
    end
   end
end
