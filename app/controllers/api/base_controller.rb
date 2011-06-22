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
      ForeignAccess.accepted_clients.select{|x| x.param_key == t}.present?
    end
   end
end
