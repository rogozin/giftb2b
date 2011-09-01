#encoding: utf-8;
class FirmMailer < ActionMailer::Base
   default :from => "notification@giftb2b.ru", :charset => "UTF-8"
   layout "/layouts/mailers/firms"
  
  
  def new_user_order_notification(firm, user, order)
    @user = user
    @order = order    
    mail(:to => firm.email, :subject => "giftb2b.ru - поступил новый заказ (#{order.id})" )
  end
  
  def new_remote_order_notification(order)
    @order = order
    mail(:to => order.firm.email, :subject => "giftb2b.ru - поступил новый заказ (#{order.id})" ) 
  end
  
end
