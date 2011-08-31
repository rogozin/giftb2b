#encoding: utf-8;
class UserMailer < ActionMailer::Base
   default :from => "notification@giftb2b.ru", :charset => "UTF-8"
   layout "/layouts/mailers/users"
  

  def new_order_notification(user, order)
    @firm = order.firm || Firm.find(1)
    @user = user
    @order = order
    mail(:to => user.email, :subject => "giftb2b.ru - новый заказ (#{order.id})")
  end
  
  def new_remote_order_notification(order)
    @firm = order.firm || Firm.find(1)    
    @order = order
    mail(:to => order.contact_email, :subject => "Ваш заказ на сайте #{@firm.url} (#{order.id})")    
  end
  
  def update_order_notification(order)
    @firm = order.firm || Firm.find(1)
    @order = order
    mail(:to => order.contact_email, :subject => "Ваш заказ на сайте #{@firm.url} (#{order.id})")    
  end
  
end
