class ServiceRole < ActiveRecord::Base
  set_primary_keys :service_id, :role_id
  belongs_to :role
  belongs_to :service
  after_create {|record| record.service.grant_privileges}
  after_destroy {|record| record.service.deny_privileges}
  
end
