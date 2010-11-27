class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_authorization_subject :role_class_name => 'Role'

  def is_admin?
    has_role? 'Администратор'
   # Rails.cache.fetch('is_admin?', :expires_in=>5) {}
  end
  
  def activate!
    self.update_attribute :active, true
  end
    
end
