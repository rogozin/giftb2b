class FirmMailer < ActionMailer::Base
  default :from => "notification@giftb2b.ru"
  
  
  def new_user_order_notification(firm, user, order)
    @user = user
    @order = order    
    mail(:to => firm.email, :subject => "giftb2b.ru - поступил новый заказ (#{order.id})" )
  end
  
end
