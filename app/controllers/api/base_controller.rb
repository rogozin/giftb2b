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
   request.headers.each {|k,v| logger.info "#{k} = #{v}"}
   #logger.info "==request auth=#{request.authorization.to_s}"
   authenticate_or_request_with_http_token do |t,o|
      access = ForeignAccess.accepted_clients.select{|x| x.param_key == t}
      #logger.info "token=#{t} opts=#{o}"
      @firm = access.first.firm if access.present?
      access.present?
    end
   end
end
