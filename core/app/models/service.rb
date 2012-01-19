class Service < ActiveRecord::Base
  has_many :service_roles, :dependent => :destroy
  has_many :roles, :through => :service_roles
  has_many :firm_services, :dependent => :delete_all
  has_many :firms, :through => :firm_services
  
  
  def grant_privileges
    firms.each{|f| f.commit_service(self)}
  end
  
  def deny_privileges
    firms.each{|f| f.rollback_service(self)}    
  end
  
end
