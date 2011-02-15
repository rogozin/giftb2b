class User < ActiveRecord::Base
  acts_as_authentic
  acts_as_authorization_subject :role_class_name => 'Role'
  belongs_to :firm
 validates :username, :exclusion => { :in => %w(admin superuser) }
  validates :appoint, :length => {:maximum => 100}
  validates :skype, :length => {:maximum => 25}
  validates :cellphone, :length => {:maximum => 25}
  validates :icq, :length => {:maximum => 25},  :numericality => {:allow_blank => true}
  
  
  def is_admin?
    Rails.cache.fetch('is_admin?', :expires_in=>10) {has_role? 'Администратор'}
  end
  
  def is_lk_user?
     Rails.cache.fetch('is_lk_user?', :expires_in=>10) {role_objects.exists?(["roles.group>0"])}
  end
  
  def is_admin_user?
     Rails.cache.fetch('is_admin_user?', :expires_in=>10) {role_objects.exists?(["roles.group=0"])}
  end
  
  def is_firm_user?
     Rails.cache.fetch('is_firm_user?', :expires_in=>10) {role_objects.exists?(["roles.group=2"])}
  end
  def activate!
    self.update_attribute :active, true
  end
    
end
