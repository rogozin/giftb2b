#encoding: utf-8;
class Auth::AccountMailer < ActionMailer::Base
   default :from => "#{default_url_options[:host]} - Сувениры для бизнеса <notification@#{default_url_options[:host] }>", :charset => "UTF-8"
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
    mail(:to => user.email, :subject => "Ваша учетная запись на сайте #{default_url_options[:host]}")
  end

  def recovery_password(user,password)
    @firm = Firm.find(1)
    @password = password
    @user = user
    mail(:to => user.email, :subject => "Восстановление пароля на сайте #{default_url_options[:host] }")
  end
  
  
end
