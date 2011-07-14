#encoding: utf-8;
class User < ActiveRecord::Base
  has_many :lk_orders
  acts_as_authentic
  acts_as_authorization_subject :role_class_name => 'Role'
  belongs_to :firm
  belongs_to :supplier
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
  
  def is_simple_user?
     Rails.cache.fetch('is_simple_user?', :expires_in=>10) {role_objects.exists?(["roles.group=1"])}
  end
  
  def is_firm_user?
     Rails.cache.fetch('is_firm_user?', :expires_in=>10) {role_objects.exists?(["roles.group=2"])}
  end
  
  def is_firm_manager?
    Rails.cache.fetch('is_firm_manager?', :expires_in=>10) { has_role?("Менеджер фирмы")}    
  end
  
  def activate!
    self.update_attribute :active, true
  end
    
end
