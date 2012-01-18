class ServiceRole < ActiveRecord::Base
  set_primary_keys :service_id, :role_id
  belongs_to :role
  belongs_to :service
  after_create :flush_roles

  
  private 
  
  def flush_roles
    FirmService.where(:service_id => self.service_id).each do |fs|
       User.where(:firm_id =>fs.firm_id).each do |user|
         user.has_role! self.role.name
       end
    end
  end
end
