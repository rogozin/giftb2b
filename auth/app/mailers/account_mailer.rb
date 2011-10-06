#encoding: utf-8;
class AccountMailer < ActionMailer::Base
   default :from => "giftb2b.ru - Сувениры для бизнеса <notification@giftb2b.ru>", :charset => "UTF-8"
   layout "/layouts/mailers/account"
  
  
  def activation_email(user)
    @firm = Firm.find(1)
    @user = user
    mail(:to => user.email, :subject => "Активация учетной записи")
  end
  
  def activation_complete(user)
    @firm = Firm.find(1)
    @user = user
    mail(:to => user.email, :subject => "Активация завершена")
  end
  
  def new_account(user,password)
    @firm = Firm.find(1)
    @password = password
    @user = user
    mail(:to => user.email, :subject => "Ваша учетная запись на сайте giftb2b.ru")
  end

  def recovery_password(user,password)
    @firm = Firm.find(1)
    @password = password
    @user = user
    mail(:to => user.email, :subject => "Восстановление пароля на сайте giftb2b.ru")
  end
  
  
end
