#encoding: utf-8;
class Auth::AdminMailer < ActionMailer::Base
   default :from => "giftb2b.ru - Администрирование <notification@giftb2b.ru>", :charset => "UTF-8"
   layout "layouts/mailers/admin"
  
  
  def new_user_registered(user, admin)
    @user = user
    mail(:to => admin.email, :subject => "Зарегистрирован новый пользователь" )
  end 
end
