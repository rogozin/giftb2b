class Api::OrdersController << Api::BaseController
  
  def create
    order = LkOrder.new(:user_comment => params[:user])
    if order.save
      render :json  => {:success => true}
    else
      remder :json => {:success => false}
    end  
  end
  
end
