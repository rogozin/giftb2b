module UsersHelper
  def is_birthday_today?
    current_user && current_user.birth_date && current_user.birth_date.day == Date.today.day && current_user.birth_date.month == Date.today.month
  end
end
