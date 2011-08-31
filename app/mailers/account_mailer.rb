#encoding: utf-8;
class AccountMailer < ActionMailer::Base
   default :from => "notification@giftb2b.ru", :charset => "UTF-8"
   layout "/layouts/mailers/users"
  
  
  def activation_email(user)
    @firm = Firm.find(1)
    @user = user
    mail(:to => user.email, :subject => "giftb2b.ru - активация учетной записи")
  end
  
  def activation_complete(user)
    @firm = Firm.find(1)
    @user = user
    mail(:to => user.email, :subject => "giftb2b.ru - активация завершена")
  end
  
  
end
