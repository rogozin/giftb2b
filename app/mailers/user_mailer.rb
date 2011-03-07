class UserMailer < ActionMailer::Base
  default :from => "notification@giftb2b.ru"
  
  def activation_email(user)
    @user = user
    mail(:to => user.email, :subject => "giftb2b.ru - активация учетной записи")
  end
  
  def activation_complete(user)
    @user = user
    mail(:to => user.email, :subject => "giftb2b.ru - активация завершена")
  end
  
end
