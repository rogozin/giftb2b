#encoding: utf-8;
module UsersHelper
  def is_birthday_today?
    current_user && current_user.birth_date && current_user.birth_date.day == Date.today.day && current_user.birth_date.month == Date.today.month
  end
  
  def user_name(user)
   user ?  (user.fio ? user.fio : user.username) : "-"
  end
  
  def who(user)    
    user ? (user.fio.present? ? user.fio : user.username) : "неизв?"
  end
  
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  
end
