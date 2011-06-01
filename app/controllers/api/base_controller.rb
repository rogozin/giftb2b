class Api::BaseController < ActionController::Base  
  respond_to :json
  
  
  private
  
#  def respond_with( object, options = {})
#    options = options.merge(:callback => params[:callback])
#    super(object, options)
#  end
end
