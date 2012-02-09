#encoding: utf-8;
class UserSession < Authlogic::Session::Base
  logout_on_timeout Rails.env.production?  
  #before_validation :check_if_expired
  self.last_request_at_threshold(10.minutes)

  def before_validation
    usr = User.find_by_username(self.username)
    return false unless usr
     errors.add(:base, "У вас закончился доступ в систему. Для продления обратитесь, пожалуйста, по тел.: +7 495 741-06-95") unless (usr.expire_date.blank? ?  Date.today : usr.expire_date) >= Date.today
     
  end

  def to_key
    res = []
    res<< id
  end
end
