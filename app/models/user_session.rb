class UserSession < Authlogic::Session::Base
  #before_validation :check_if_expired


  def before_validation
    usr = User.find_by_username(self.username)
    return false unless usr
     errors.add(:base, "Срок действия учетной записи истек") unless (usr.expire_date.blank? ?  Date.today : usr.expire_date) >= Date.today
     
  end

  def to_key
    res = []
    res<< self.id
  end
end
